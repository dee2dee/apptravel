package middleware

import (
	"net/http"
	"os"

	"github.com/gin-gonic/gin"
)

func ApiKeyAuth() gin.HandlerFunc {
	return func(c *gin.Context) {
		apiKey := c.GetHeader("X-API-KEY")
		apiKeyEnv := os.Getenv("API_KEY")
		if apiKey != apiKeyEnv {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "401 Unauthorized"})
			c.Abort()
			return
		}
		c.Next()
	}
}
