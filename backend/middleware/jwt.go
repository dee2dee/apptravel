package middleware

import (
	"apptravel/backend/models"
	"crypto/rand"
	"encoding/hex"
	"errors"
	"net/http"
	"os"
	"strings"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt/v5"
)

var jwtSecret = []byte(os.Getenv("JWT_SECRET"))

// Generate JWT
func GenerateJWT(userID int, deviceRef string, sessionID int) (string, error) {
	claims := jwt.MapClaims{
		"user_id":    userID,
		"device_ref": deviceRef,
		"session_id": sessionID,
		"exp":        time.Now().Add(1 * time.Hour).Unix(), // 1 jam
		"iat":        time.Now().Unix(),                    // Waktu token dibuat
	}
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	return token.SignedString(jwtSecret)
}

// GenerateRefreshToken membuat random string panjang
func GenerateRefreshToken() (string, error) {
	bytes := make([]byte, 32) // 32 byte = 64 karakter hex
	if _, err := rand.Read(bytes); err != nil {
		return "", err
	}
	return hex.EncodeToString(bytes), nil
}

// JWTAuth middleware validasi access token
func JWTAuth() gin.HandlerFunc {
	return func(c *gin.Context) {
		authHeader := c.GetHeader("Authorization")
		if authHeader == "" || !strings.HasPrefix(authHeader, "Bearer ") {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized - Token missing"})
			c.Abort()
			return
		}

		tokenString := strings.TrimPrefix(authHeader, "Bearer ")

		// Parse token dengan validasi metode signing
		token, err := jwt.Parse(tokenString, func(token *jwt.Token) (any, error) {
			if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
				return nil, errors.New("invalid signing method")
			}
			return jwtSecret, nil
		})

		if err != nil || !token.Valid {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized - Invalid token"})
			c.Abort()
			return
		}

		claims, ok := token.Claims.(jwt.MapClaims)
		if !ok {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized - Invalid claims"})
			c.Abort()
			return
		}

		// Ambil data claims
		userID := int(claims["user_id"].(float64))
		deviceRef := claims["device_ref"].(string)
		sessionID := int(claims["session_id"].(float64))

		// Cek session di DB
		var session models.UserSession
		if err := models.DB.Where("id = ? AND user_id = ? AND device_ref = ? AND revoked = ?", sessionID, userID, deviceRef, false).First(&session).Error; err != nil {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized - Session invalid"})
			c.Abort()
			return
		}

		// Cek expired di DB (lebih valid daripada hanya klaim JWT)
		if time.Now().After(session.ExpiresAt) {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized - Session expired"})
			c.Abort()
			return
		}

		// Simpan ke context
		c.Set("user_id", userID)
		c.Set("device_ref", deviceRef)
		c.Set("session_id", sessionID)
		c.Next()
	}
}
