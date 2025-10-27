package utils

import (
	"crypto/hmac"
	"crypto/sha256"
	"encoding/hex"
	"fmt"
	"os"
	"time"
)

func SignSecret() (string, string, string) {
	apiKey := os.Getenv("API_KEY")
	otpSecret := os.Getenv("OTP_SECRET")

	if apiKey == "" || otpSecret == "" {
		panic("API_KEY / OTP_SECRET belum ada. Jalankan generator_secret.go dulu!")
	}

	// generate timestamp
	timestamp := fmt.Sprintf("%d", time.Now().Unix())

	// Signature = HMAC.SHA256(secret, apiKey + timestamp)
	mac := hmac.New(sha256.New, []byte(otpSecret))
	mac.Write([]byte(apiKey + timestamp))
	signature := hex.EncodeToString(mac.Sum(nil))

	fmt.Println("Request signature generated")

	return apiKey, timestamp, signature
}
