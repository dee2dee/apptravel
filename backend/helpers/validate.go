package helpers

import (
	"errors"
	"regexp"
	"strings"
	"unicode"
)

func ValidatePhone(phone string) (string, error) {
	phone = strings.TrimSpace(phone)

	// Hapus semua karakter selain angka
	regex := regexp.MustCompile(`^[0-9]`)
	phoneDigits := regex.ReplaceAllString(phone, "")

	if phoneDigits == "" {
		return "", errors.New("nomor telepon tidak boleh kosong")
	}

	// Auto-format nomor telepon: jika diawali 0, ubah menjadi +62
	if strings.HasPrefix(phoneDigits, "0") {
		phoneDigits = "+62" + phoneDigits[1:]
	}

	// Pastikan awalan +62
	if !strings.HasPrefix(phoneDigits, "+62") {
		return "", errors.New("nomor telepon harus diawali dengan +62")
	}

	// Ambil bagian setelah +62
	phoneNumber := phoneDigits[3:]

	// Validasi panjang 10-14 digit
	if len(phoneNumber) < 10 || len(phoneNumber) > 12 {
		return "", errors.New("nomor telepon harus 10-14 digit setelah +62")
	}

	// Validasi hanya angka setelah +62
	regDigits := regexp.MustCompile(`^[0-9]+$`)
	if !regDigits.MatchString(phoneNumber) {
		return "", errors.New("nomor telepon hanya boleh mengandung angka setelah +62")
	}

	return phoneDigits, nil

}

func HasLetterAndNumber(s string) bool {
	hasLetter := false
	hasNumber := false

	for _, char := range s {
		switch {
		case unicode.IsLetter(char):
			hasLetter = true
		case unicode.IsNumber(char):
			hasNumber = true
		}
	}
	return hasLetter && hasNumber
}
