# AppTravel — Travel Ticket Booking System

AppTravel adalah aplikasi **pemesanan tiket travel (bus/shuttle)** yang dibangun menggunakan **Flutter** untuk frontend dan **Golang (Gin Framework)** untuk backend API. 
Proyek ini dikembangkan sebagai inisiatif pribadi untuk memperdalam pemahaman tentang **arsitektur full-stack**, **autentikasi pengguna**, dan **manajemen tiket berbasis REST API**.

---

## Struktur Project

apptravel/  
├── android/       # Source code untuk platform Android  
├── ios/           # Source code untuk platform iOS  
├── linux/         # Support untuk Linux build (Flutter)  
├── macos/         # Support untuk macOS build (Flutter)  
├── windows/       # Support untuk Windows build (Flutter)  
├── web/           # Support untuk web build (Flutter)  
│  
├── lib/           # Kode utama aplikasi Flutter (frontend)  
├── assets/        # Asset gambar/icon aplikasi  
│  
├── backend/       # Backend API (Golang)  
│ ├── controllers/ # Logic dari masing-masing endpoint  
│ ├── middleware/  # Middleware API Key & JWT  
│ ├── routes/      # Definisi semua route endpoint  
│ ├── models/      # Struktur data dan koneksi database (planned)  
│ └── main.go      # Entry point backend server  
│  
├── go.mod         # Modul Go untuk backend  
├── go.sum         # Dependensi Go  
│  
├── pubspec.yaml   # Konfigurasi dependencies Flutter  
├── pubspec.lock   # Lock file Flutter  
├── build/         # Folder hasil build Flutter  
└── README.md      # Dokumentasi proyek  


---

## Teknologi yang Digunakan

### Backend
- **Go (Golang)**
- **Gin Gonic** — Web framework
- **JWT** — Autentikasi berbasis token
- **API Key Middleware** — Keamanan untuk OTP route
- **MySQL / PostgreSQL** *(planned)* — Database utama
- **Docker** *(planned)* — Containerization

### Frontend
- **Flutter (Dart)**
- **Material Design Components**
- **HTTP Client** untuk komunikasi dengan backend API

---

## Fitur yang Sudah Dikembangkan

### Backend Endpoint (Golang)
| Method | Endpoint | Deskripsi |
|--------|---------------------|------------------------------------------|
| `GET`  | `/ping`             | Mengecek status server (respons: `pong`) |
| `POST` | `/otp/register`     | Registrasi user baru via OTP             |
| `POST` | `/otp/generate`     | Generate OTP baru                        |
| `POST` | `/otp/verification` | Verifikasi OTP                           |
| `POST` | `/auth/refresh`     | Refresh token JWT                        |
| `POST` | `/auth/logout`      | Logout user (revoke token)               |
| `GET`  | `/auth/users`       | Mendapatkan data user login              |

---

## Fitur yang Akan Datang

- [ ] Integrasi database (MySQL / PostgreSQL)  
- [ ] CRUD pemesanan tiket  
- [ ] Integrasi payment gateway (Midtrans / Xendit)  
- [ ] Dokumentasi Swagger API  
- [ ] Deployment backend ke cloud (Railway / Render / AWS)  
- [ ] Integrasi penuh Flutter app dengan backend  

---

## Cara Menjalankan Backend

1. Masuk ke folder backend
```bash
cd backend

2. Install dependencies
go mod tidy

3. Jalankan server
go run main.go

4. Tes endpoint
GET http://localhost:8080/ping

Respons:
{"message": "pong"}

---

## Cara Menjalankan Backend

1. Masuk ke root folder proyek
cd apptravel

2. Jalankan Flutter
flutter pub get
flutter run

```

## Tentang Developer
Saya adalah seorang Back End Developer pemula yang sedang belajar membangun aplikasi end-to-end (Flutter + Go).
Fokus saya adalah memahami konsep:
RESTful API Design
Authentication & Authorization
Database Integration
Clean Code & Modular Structure

UI/UX : https://www.figma.com/design/ekdujmsA62Oq0CW0Cu3hah?node-id=0-1  
Status: Dalam Pengembangan  
Kontak: dedeeapr17@gmail.com  
GitHub: https://github.com/dee2dee/apptravel  
*Terbuka untuk kolaborasi dalam pengembangan  

---

## Lisensi
Proyek ini dikembangkan untuk tujuan pembelajaran dan pengembangan pribadi.  
Bebas digunakan sebagai referensi atau bahan belajar dengan mencantumkan atribusi yang sesuai.

