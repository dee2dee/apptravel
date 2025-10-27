package utils

import (
	"crypto/hmac"
	"crypto/rand"
	"crypto/sha256"
	"encoding/hex"
	"fmt"
	"math/big"
	"os"
)

// GenerateNumericOTP generates a 6-digit numeric OTP.
func GenerateNumericOTP(length int) string {
	if length <= 0 {
		length = 6
	}

	otp := ""
	for i := 0; i < length; i++ {
		// Ambil random digit antara 0-9
		n, err := rand.Int(rand.Reader, big.NewInt(10))
		if err != nil {
			panic(err)
		}
		otp += fmt.Sprintf("%d", n.Int64())
	}
	return otp
}

// HashOTP membuat hash HMAC-SHA256 dari kode OTP.
func HashOTP(otp string) string {
	secret := os.Getenv("OTP_SECRET")
	h := hmac.New(sha256.New, []byte(secret))
	h.Write([]byte(otp))
	return hex.EncodeToString(h.Sum(nil))
}

// VerifyOTP memverifikasi kode OTP dengan hash yang diberikan.
func VerifyOTPHASH(otp string, storedHash string) bool {
	secret := os.Getenv("OTP_SECRET")
	h := hmac.New(sha256.New, []byte(secret))
	h.Write([]byte(otp))
	expected := hex.EncodeToString(h.Sum(nil))
	return hmac.Equal([]byte(expected), []byte(storedHash))
}
