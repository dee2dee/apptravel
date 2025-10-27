package controllers

import (
	"apptravel/backend/helpers"
	"apptravel/backend/models"
	"net/http"
	"strings"

	"github.com/gin-gonic/gin"
	"golang.org/x/crypto/bcrypt"
)

type RegisterInput struct {
	FullName string      `json:"full_name" binding:"required"`
	Gender   string      `json:"gender" binding:"required"`
	Phone    string      `json:"phone" binding:"required"`
	Email    string      `json:"email" binding:"required,email"`
	Password string      `json:"password" binding:"required,min=6"`
	Role     string      `json:"role" binding:"required"`
	Device   DeviceInput `json:"device"`
}

type DeviceInput struct {
	DeviceID  string `json:"device_id"`
	Platform  string `json:"platform"`
	Model     string `json:"model"`
	Brand     string `json:"brand"`
	OSVersion string `json:"os_version"`
}

func RegisterUser(c *gin.Context) {
	var input RegisterInput
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// Validasi fullname
	if len(input.FullName) < 3 || len(input.FullName) > 14 {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Fullname harus antara 3-14 karakter"})
		return
	}

	// Validasi gender
	if input.Gender != "Laki-laki" && input.Gender != "Perempuan" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Gender harus 'Laki-laki' atau 'Perempuan'"})
		return
	}

	// Validasi email
	if !strings.Contains(input.Email, "@") || !strings.Contains(input.Email, ".") {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Email tidak valid"})
		return
	}

	// Validasi nomor telepon
	formattedPhone, err := helpers.ValidatePhone(input.Phone)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	input.Phone = formattedPhone

	// Validasi password
	if len(input.Password) < 8 {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Password minimal 8 karakter"})
		return
	}
	if !helpers.HasLetterAndNumber(input.Password) {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Password harus mengandung huruf dan angka"})
		return
	}

	// Cek email apakah sudah dipakai
	var userByEmail models.User
	if err := models.DB.Where("email = ?", input.Email).First(&userByEmail).Error; err == nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Email sudah terdaftar"})
		return
	}

	// Cek nomor telepon apakah sudah dipakai
	var userByPhone models.User
	if err := models.DB.Where("phone = ?", input.Phone).First(&userByPhone).Error; err == nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Nomor telepon sudah terdaftar"})
		return
	}

	// Hash password
	hashPassword, err := bcrypt.GenerateFromPassword([]byte(input.Password), bcrypt.DefaultCost)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Gagal mengenkripsi password"})
		return
	}

	// Tentukan status berdasarkan role
	var status string
	switch strings.ToLower(input.Role) {
	case "customer":
		status = "active"
	case "driver":
		status = "pending"
	default:
		c.JSON(http.StatusBadRequest, gin.H{"error": "Role tidak valid"})
		return
	}

	// Simpan user
	user := models.User{
		FullName: input.FullName,
		Gender:   input.Gender,
		Phone:    input.Phone,
		Email:    input.Email,
		Password: string(hashPassword),
		Role:     input.Role,
		Status:   status,
	}

	if err := models.DB.Create(&user).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"status":  false,
			"message": "Gagal menyimpan user",
		})
		return
	}

	// Simpan device
	device := models.Device{
		UserID:    user.ID,
		DeviceID:  input.Device.DeviceID,
		Platform:  input.Device.Platform,
		Model:     input.Device.Model,
		Brand:     input.Device.Brand,
		OSVersion: input.Device.OSVersion,
		IsTrusted: true,
	}
	if err := models.DB.Create(&device).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Gagal menyimpan device"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"status":  true,
		"message": "Registrasi berhasil",
		"user":    user,
		"device":  device,
	})
}
