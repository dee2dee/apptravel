package models

import "time"

type User struct {
	ID        int       `gorm:"primaryKey" json:"id"`
	FullName  string    `gorm:"size:20;not null" json:"full_name"`
	Gender    string    `gorm:"size:20" json:"gender"`
	Phone     string    `gorm:"size:20" json:"phone"`
	Email     string    `gorm:"size:100;unique" json:"email"`
	Password  string    `gorm:"size:255;not null" json:"-"`
	Role      string    `gorm:"size:20;not null" json:"role"`
	Status    string    `gorm:"size:20;not null" json:"status"`
	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`
}

type Otp struct {
	ID        int       `gorm:"primaryKey" json:"id"`
	UserID    int       `json:"user_id"`
	DeviceRef string    `gorm:"column:device_ref" json:"device_ref"`
	Phone     string    `json:"phone"`
	RequestIP string    `json:"request_ip"`
	CodeHash  string    `json:"code_hash"`
	ExpiredAt time.Time `json:"expired_at"`
	CreatedAt time.Time `json:"created_at"`
	Attempts  int       `json:"attempts"`
}

type OtpLog struct {
	ID        int       `gorm:"primaryKey;autoIncrement"`
	UserID    int       `json:"user_id"`
	DeviceRef string    `gorm:"column:device_ref" json:"device_ref"`
	IPAddress string    `json:"ip_address"`
	Action    string    `json:"action"`
	Status    string    `json:"status"`
	Message   string    `json:"message"`
	CreatedAt time.Time `gorm:"autoCreateTime" json:"created_at"`
}

type OtpRateLimit struct {
	ID             int        `gorm:"primaryKey" json:"id"`
	UserID         int        `gorm:"not null" json:"user_id"`
	DeviceRef      string     `gorm:"column:device_ref" json:"device_ref"`
	IPAddress      string     `gorm:"size:45;not null" json:"ip_address"`
	FailedAttempts int        `gorm:"default:0" json:"failed_attempts"`
	LockedUntil    *time.Time `json:"locked_until"`
	LastRequest    time.Time  `gorm:"autoCreateTime" json:"last_request"`
	CreatedAt      time.Time
	UpdatedAt      time.Time
}

type Device struct {
	ID        int       `gorm:"primaryKey" json:"id"`
	UserID    int       `gorm:"not null;index" json:"user_id"`
	DeviceID  string    `gorm:"size:100;not null" json:"device_id"`
	Platform  string    `gorm:"type:enum('android','ios');not null" json:"platform"`
	Model     string    `gorm:"size:100" json:"model"`
	Brand     string    `gorm:"size:50" json:"brand"`
	OSVersion string    `gorm:"size:50" json:"os_version"`
	IsTrusted bool      `gorm:"default:false" json:"is_trusted"`
	CreatedAt time.Time `gorm:"autoCreateTime" json:"created_at"`
}

type UserSession struct {
	ID               int       `gorm:"primaryKey" json:"id"`
	UserID           int       `gorm:"not null;index" json:"user_id"`
	DeviceRef        string    `gorm:"column:device_ref" json:"device_ref"`
	Token            string    `gorm:"size:512;not null" json:"token"`
	RefreshToken     string    `gorm:"size:512;not null" json:"refresh_token"`
	ExpiresAt        time.Time `json:"expires_at"`
	RefreshExpiresAt time.Time `json:"refresh_expires_at"`
	Revoked          bool      `gorm:"default:false" json:"revoked"`
	CreatedAt        time.Time `gorm:"autoCreateTime" json:"created_at"`
}
