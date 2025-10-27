package worker

import (
	"apptravel/backend/models"
	"log"
	"time"
)

func StartOTPCleaner() {
	ticker := time.NewTicker(1 * time.Minute) // Cek tiap 1 menit
	go func() {
		for {
			<-ticker.C
			now := time.Now()
			result := models.DB.Where("expired_at < ?", now).Delete(&models.Otp{})
			if result.Error != nil {
				log.Println("Error cleaning expired OTPs:", result.Error)
			} else if result.RowsAffected > 0 {
				log.Printf("Expired OTPs cleaned: %d\n", result.RowsAffected)
			}
		}
	}()
}
