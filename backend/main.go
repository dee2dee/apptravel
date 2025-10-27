package main

import (
	"apptravel/backend/models"
	"apptravel/backend/routes"
	"apptravel/backend/utils"
	"apptravel/backend/worker"
	"fmt"
	"log"
	"os"

	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
)

func main() {
	// Load environment variables
	err := godotenv.Load()
	if err != nil {
		log.Println("Tidak bisa load .env, pakai default OS ENV")
	}

	// Koneksi ke database
	models.InitDB()

	// Start background job
	worker.StartOTPCleaner()

	// Init Gin router
	r := gin.Default()

	// Register routes
	routes.RegisterRoutes(r)

	// Ambil port dari environment variable
	port := os.Getenv("APP_PORT")
	if port == "" {
		port = "8080"
	}

	apiKey, timestamp, signature := utils.SignSecret()

	fmt.Printf("API_KEY: %s\n", apiKey)
	fmt.Printf("TIMESTAMP: %s\n", timestamp)
	fmt.Printf("SIGNATURE: %s\n", signature)

	log.Println("Server running on port", port)
	// Run server
	r.Run(":" + port) // listen and serve on

}
