package routes

import (
	"apptravel/backend/controllers"
	"apptravel/backend/middleware"

	"github.com/gin-gonic/gin"
)

// RegisterRoutes untuk setup semua endpoint
func RegisterRoutes(r *gin.Engine) {
	// Test endpoint
	r.GET("/ping", func(c *gin.Context) {
		c.JSON(200, gin.H{"message": "pong"})
	})

	// OTP routes (pakai API Key)
	otpGroup := r.Group("/otp", middleware.ApiKeyAuth())
	{
		otpGroup.POST("/register", controllers.RegisterUser)
		otpGroup.POST("/generate", controllers.GenerateOTP)
		otpGroup.POST("/verification", controllers.VerifyOTP)
	}

	// Auth routes (setelah OTP verify)
	authGroup := r.Group("/auth")
	{
		authGroup.POST("/refresh", controllers.RefreshToken) // refresh token endpoint
		authGroup.POST("/logout", middleware.JWTAuth(), controllers.Logout)
		authGroup.GET("/users", controllers.GetUser) // revoke session
	}

}
