package controllers

import (
	"apptravel/backend/middleware"
	"apptravel/backend/models"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
)

func RefreshToken(c *gin.Context) {
	var req struct {
		RefreshToken string `json:"refresh_token" binding:"required"`
	}
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request"})
		return
	}

	// Cari session berdasarkan refresh_token
	var session models.UserSession
	if err := models.DB.Where("refresh_token = ? AND revoked = ?", req.RefreshToken, false).First(&session).Error; err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid refresh token"})
		return
	}

	// Cek expired refresh token
	if time.Now().After(session.RefreshExpiresAt) {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Refresh token expired"})
		return
	}

	// Generate new access token
	accessToken, err := middleware.GenerateJWT(session.UserID, session.DeviceRef, session.ID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "could not generate new access token"})
		return
	}

	// Update session -> access token + expired_at baru
	session.Token = accessToken
	session.ExpiresAt = time.Now().Add(1 * time.Hour) // Misalnya 1 jam lagi
	if err := models.DB.Save(&session).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "could not update session"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"access_token": accessToken,
		"expires_at":   3600, // detik
	})
}

func Logout(c *gin.Context) {
	userID := c.GetInt("user_id")
	sessionID := c.GetInt("session_id")

	// Debug
	c.JSON(200, gin.H{
		"debug_user_id":    userID,
		"debug_session_id": sessionID,
	})

	// Revoke session di DB
	if err := models.DB.Model(&models.UserSession{}).Where("id = ? AND user_id = ?", sessionID, userID).Update("revoked", true).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Could not revoke session"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "Logout successful. Session revoked.",
	})
}

func GetUser(c *gin.Context) {
	var users models.User
	// Ambil user dari database, bisa batasi LIMIT jika mau
	if err := models.DB.Raw("SELECT full_name, email, phone FROM users").Scan(&users).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Could not fetch users"})
		return
	}

	// Kembalikan array users
	c.JSON(http.StatusOK, gin.H{
		"full_name": users.FullName,
		"email":     users.Email,
		"phone":     users.Phone,
	})
}
