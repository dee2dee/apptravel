package controllers

import (
	"apptravel/backend/helpers"
	"apptravel/backend/middleware"
	"apptravel/backend/models"
	"apptravel/backend/utils"
	"errors"
	"fmt"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
	"gorm.io/gorm/clause"
)

// GenerateOTP handler untuk membuat OTP dengan rate limit + progressive lockout
func GenerateOTP(c *gin.Context) {
	var req struct {
		Phone    string `json:"phone" binding:"required"`
		DeviceId string `json:"device_id" binding:"required"`
	}
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request"})
		return
	}

	// Validasi nomor telepon
	formattedPhone, err := helpers.ValidatePhone(req.Phone)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	req.Phone = formattedPhone

	// Cek apakah user sudah ada
	var user models.User
	if err := models.DB.Where("phone = ?", req.Phone).First(&user).Error; err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			// User tidak ditemukan
			c.JSON(http.StatusNotFound, gin.H{
				"error": "Nomor telepon belum terdaftar",
			})
			return
		}

		// Error lainya misal koneksi
		c.JSON(http.StatusInternalServerError, gin.H{
			"error": "Terjadi kesalahan pada server",
		})
		return
	}

	// Cek device
	var device models.Device
	if err := models.DB.Where("device_id = ?", req.DeviceId).First(&device).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Device not found"})
		return
	}

	ip := c.ClientIP()
	now := time.Now()
	cutoff := now.Add(-2 * time.Minute)

	// Mulai transaksi supaya update rateLimit + generate OTP konsisten
	tx := models.DB.Begin()
	defer func() {
		if r := recover(); r != nil {
			tx.Rollback()
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Internal error"})
		}
	}()

	// Ambil record rate limit untuk device
	var rateLimit models.OtpRateLimit
	if err := tx.Clauses(clause.Locking{Strength: "UPDATE"}).Where("user_id = ? AND device_ref = ?", user.ID, req.DeviceId).First(&rateLimit).Error; err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			rateLimit = models.OtpRateLimit{
				UserID:         user.ID,
				DeviceRef:      req.DeviceId,
				IPAddress:      ip,
				FailedAttempts: 0,
				LastRequest:    now,
			}
			if err := tx.Create(&rateLimit).Error; err != nil {
				tx.Rollback()
				c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create rate limit"})
				return
			}
		} else {
			tx.Rollback()
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Rate limit check failed"})
			return
		}
	}

	// Kalau masih locked
	if rateLimit.LockedUntil != nil && rateLimit.LockedUntil.After(now) {
		tx.Rollback()
		c.JSON(http.StatusTooManyRequests, gin.H{
			"error": fmt.Sprintf("Too many requests. Try again after %s", rateLimit.LockedUntil.Format("15:04:05")),
		})
		return
	}

	// Hitung request dari device ini
	var deviceCount int64
	if err := tx.Model(&models.OtpLog{}).Where("user_id = ? AND device_ref = ? AND action = ? AND created_at >= ?", user.ID, req.DeviceId, "request", cutoff).Count(&deviceCount).Error; err != nil {
		tx.Rollback()
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to check device requests"})
		return
	}

	// Hitung request global untuk user (semua device)
	var userCount int64
	if err := tx.Model(&models.OtpLog{}).Where("user_id = ? AND action = ? AND created_at >= ?", user.ID, "request", cutoff).Count(&userCount).Error; err != nil {
		tx.Rollback()
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to check user requests"})
		return
	}

	// Batas spam device: 5x / 2 menit
	if deviceCount >= 5 {
		lockedUntil := now.Add(30 * time.Second)
		rateLimit.LockedUntil = &lockedUntil
		rateLimit.FailedAttempts = int(deviceCount)
		_ = tx.Save(&rateLimit)

		_ = tx.Create(&models.OtpLog{
			UserID:    user.ID,
			DeviceRef: req.DeviceId,
			IPAddress: ip,
			Action:    "request",
			Status:    "failed",
			Message:   "Device locked 30s (spam)",
			CreatedAt: now,
		})

		tx.Commit()
		c.JSON(http.StatusTooManyRequests, gin.H{"error": "Terlalu banyak request dari device ini"})
		return
	}

	// Batas spam user global: 10x / 2 menit (semua device)
	if userCount >= 10 {
		// Lock semua device user (update bulk)
		lockUntil := now.Add(1 * time.Minute)
		if err := tx.Model(&models.OtpRateLimit{}).Where("user_id = ?", user.ID).Updates(map[string]interface{}{
			"locked_until":    lockUntil,
			"failed_attempts": userCount,
		}).Error; err != nil {
			tx.Rollback()
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update user lock"})
			return
		}

		_ = tx.Create(&models.OtpLog{
			UserID:    user.ID,
			DeviceRef: req.DeviceId,
			IPAddress: ip,
			Action:    "request",
			Status:    "failed",
			Message:   "User locked 1m (global spam)",
			CreatedAt: now,
		})

		tx.Commit()
		c.JSON(http.StatusTooManyRequests, gin.H{"error": "Terlalu banyak request OTP untuk nomor ini. Tunggu 1 menit"})
		return
	}

	// Selalu hapus OTP lama
	_ = tx.Where("user_id = ? AND device_ref = ?", user.ID, req.DeviceId).Delete(&models.Otp{})

	// Generate OTP 6 digit
	otp := utils.GenerateNumericOTP(6)
	otpHash := utils.HashOTP(otp)

	// Simpan OTP baru ke DB
	newOTP := models.Otp{
		UserID:    user.ID,
		CodeHash:  otpHash,
		DeviceRef: req.DeviceId,
		Phone:     req.Phone,
		RequestIP: ip,
		ExpiredAt: time.Now().Add(2 * time.Minute), // OTP berlaku 2 menit
		CreatedAt: now,
		Attempts:  0,
	}
	if err := tx.Create(&newOTP).Error; err != nil {
		tx.Rollback()
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create OTP"})
		return
	}

	// Catat log success
	_ = tx.Create(&models.OtpLog{
		UserID:    user.ID,
		DeviceRef: req.DeviceId,
		IPAddress: ip,
		Action:    "request",
		Status:    "success",
		Message:   "OTP generated",
		CreatedAt: now,
	}).Error

	// Commit transaction
	if err := tx.Commit().Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to finalize request"})
		return
	}

	// RESPON untuk testing (jangan kirim OTP plaintext di production)
	c.JSON(http.StatusOK, gin.H{
		"otp":        otp, // Untuk testing only, di production jangan kirim OTP ini
		"user_id":    newOTP.UserID,
		"device_ref": newOTP.DeviceRef,
		"expired_at": newOTP.ExpiredAt.Format("2006-01-02 15:04:05"),
		"message":    "OTP generated successfully",
	})
}

// VerifyOTP handler untuk cek OTP & buat session
func VerifyOTP(c *gin.Context) {
	var req struct {
		UserID    int    `json:"user_id" binding:"required"`
		Otp       string `json:"otp" binding:"required"`
		DeviceRef string `json:"device_ref" binding:"required"`
	}
	if err := c.ShouldBindJSON(&req); err != nil {
		fmt.Println("Failed to bind JSON:", err)
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request"})
		return
	}

	ip := c.ClientIP()

	// Cek OTP
	var otp models.Otp
	if err := models.DB.Where("user_id = ? AND device_ref = ?", req.UserID, req.DeviceRef).First(&otp).Error; err != nil {
		//----Boleh nanti di hapus.
		// Log gagal
		models.DB.Create(&models.OtpLog{
			UserID:    req.UserID,
			Action:    "verify",
			Status:    "failed",
			IPAddress: ip,
			DeviceRef: req.DeviceRef,
			Message:   "OTP not found",
		})
		//----
		c.JSON(http.StatusUnauthorized, gin.H{"error": "OTP tidak ditemukan"})
		return
	}

	// Cek expired
	if time.Now().After(otp.ExpiredAt) {
		// Hapus OTP biar tidak bisa dipakai lagi
		models.DB.Delete(&otp)

		//----Boleh nanti di hapus.
		models.DB.Create(&models.OtpLog{
			UserID:    req.UserID,
			Action:    "verify",
			Status:    "failed",
			IPAddress: ip,
			DeviceRef: req.DeviceRef,
			Message:   "OTP expired",
		})
		//----
		c.JSON(http.StatusUnauthorized, gin.H{"error": "OTP expired"})
		return
	}

	// Cek kode OTP
	if !utils.VerifyOTPHASH(req.Otp, otp.CodeHash) {
		otp.Attempts++
		models.DB.Save(&otp)

		//----Boleh nanti di hapus.
		// Log gagal percobaan
		models.DB.Create(&models.OtpLog{
			UserID:    req.UserID,
			Action:    "verify",
			Status:    "failed",
			IPAddress: ip,
			DeviceRef: req.DeviceRef,
			Message:   fmt.Sprintf("Wrong OTP - attempt %d", otp.Attempts),
		})
		//----

		if otp.Attempts >= 3 {
			models.DB.Delete(&otp) // Hapus kalau gagal 3x
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid OTP"})
			return
		}

		c.JSON(http.StatusUnauthorized, gin.H{
			"error":    "OTP salah",
			"attempts": otp.Attempts,
		})
		return
	}

	// === Mulai Transaction ===
	tx := models.DB.Begin()
	defer func() {
		if r := recover(); r != nil {
			tx.Rollback() // otomatis rollback jika panic atau return
		}
	}()

	// Hapus OTP (valid)
	if err := tx.Delete(&otp).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to delete OTP"})
		return
	}

	// Reset rate limit
	if err := tx.Model(&models.OtpRateLimit{}).Where("user_id = ? AND device_ref = ?", req.UserID, req.DeviceRef).Updates(map[string]any{
		"failed_attempts": 0,
		"locked_until":    nil,
		"last_request":    time.Now(),
	}).Error; err != nil {
		tx.Rollback()
		c.JSON(http.StatusInternalServerError, gin.H{"error": "could not reset rate limit"})
		return
	}

	// Cek session aktif di device ini
	var existingSession models.UserSession
	if err := tx.Where("user_id = ? AND device_ref = ?", req.UserID, req.DeviceRef).First(&existingSession).Error; err == nil {
		if existingSession.ExpiresAt.After(time.Now()) {
			// Hapus session lama
			if err := tx.Delete(&existingSession).Error; err != nil {
				c.JSON(http.StatusInternalServerError, gin.H{"error": "could not replace old session"})
				return
			}
		}
	}

	// Buat session kosong dulu untuk dapat session.ID
	session := models.UserSession{
		UserID:           req.UserID,
		DeviceRef:        req.DeviceRef,
		RefreshToken:     "",
		ExpiresAt:        time.Now().Add(1 * time.Hour),
		RefreshExpiresAt: time.Now().Add(7 * 24 * time.Hour),
		Revoked:          false,
	}

	if err := tx.Create(&session).Error; err != nil {
		tx.Rollback()
		c.JSON(http.StatusInternalServerError, gin.H{"error": "could not create session"})
		return
	}

	// Generate refresh token
	refreshToken, err := middleware.GenerateRefreshToken()
	if err != nil {
		tx.Rollback()
		c.JSON(http.StatusInternalServerError, gin.H{"error": "could not generate refresh token"})
		return
	}

	// Generate JWT dengan session.ID yang valid
	accessToken, err := middleware.GenerateJWT(req.UserID, req.DeviceRef, session.ID)
	if err != nil {
		tx.Rollback()
		c.JSON(http.StatusInternalServerError, gin.H{"error": "could not generate token"})
		return
	}

	// Update session dengan token dan refresh token
	session.Token = accessToken
	session.RefreshToken = refreshToken
	if err := tx.Save(&session).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "could not update session"})
		return
	}

	// Ambil user berdasarkan UserID yang diverifikasi
	var user models.User
	if err := models.DB.First(&user, req.UserID).Error; err != nil {
		tx.Rollback()
		c.JSON(http.StatusInternalServerError, gin.H{"error": "user tidak ditemukan"})
		return
	}

	// Commit transaksi
	if err := tx.Commit().Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "could not commit transaction"})
		return
	}

	// Logging sukses
	models.DB.Create(&models.OtpLog{
		UserID:    req.UserID,
		Action:    "verify",
		Status:    "success",
		IPAddress: ip,
		DeviceRef: req.DeviceRef,
		Message:   "OTP verified",
	})

	// Response
	c.JSON(http.StatusOK, gin.H{
		"message":            "OTP verified successfully",
		"token":              accessToken,
		"refresh_token":      refreshToken,
		"expires_at":         3600,        // 1 jam
		"refresh_expires_at": 2592000,     // 30 hari
		"role":               user.Role,   // customer / driver
		"status":             user.Status, // pending / active
	})

}
