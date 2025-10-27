package middleware

import (
	"apptravel/backend/models"
	"errors"
	"time"

	"gorm.io/gorm"
)

func CheckRateLimit(userID int, deviceRef, ip string) (*models.OtpRateLimit, error) {
	var rl models.OtpRateLimit
	err := models.DB.Where("user_id = ? AND device_ref = ?", userID, deviceRef).First(&rl).Error
	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			rl = models.OtpRateLimit{
				UserID:         userID,
				DeviceRef:      deviceRef,
				IPAddress:      ip,
				FailedAttempts: 0,
				LastRequest:    time.Now(),
				LockedUntil:    nil, // belum pernah lock
			}
			if err := models.DB.Create(&rl).Error; err != nil {
				return nil, err
			}
			return &rl, nil
		}
		return nil, err
	}
	return &rl, nil
}
