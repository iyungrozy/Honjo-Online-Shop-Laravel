[Baca dalam Bahasa Indonesia](README-ID.md) [Read in English](README.md)


# Lingkungan Pengembangan Laravel Berbasis Docker

Repositori ini berisi lingkungan pengembangan Laravel berbasis Docker yang memungkinkan Anda menjalankan Laravel tanpa bergantung pada lingkungan Windows lokal seperti Laragon. Pengaturan ini dirancang untuk kompatibilitas lintas platform.

## Prasyarat

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) terinstal dan berjalan
- Git (opsional, untuk kontrol versi)

## Konfigurasi Port

Lingkungan ini menggunakan port khusus untuk menghindari konflik dengan layanan lain:

- **Server Web**: Port 7890 (http://localhost:7890)
- **Basis Data MySQL**: Port 7891 (untuk koneksi dengan alat eksternal)

## Instalasi

### Penyiapan Cepat Menggunakan Skrip

Proyek ini menyertakan skrip penyiapan untuk sistem berbasis Windows dan Unix untuk mengotomatisasi proses instalasi:

#### Untuk Windows:
Jalankan perintah berikut di PowerShell:

```powershell
.\setup.ps1
```

#### Untuk macOS/Linux:
Jalankan perintah berikut di Terminal:

```bash
chmod +x setup.sh
./setup.sh
```

### Instalasi Manual

Jika Anda lebih suka pengaturan manual, ikuti langkah-langkah berikut:
1. Klon repositori ini (atau unduh)
   ```bash
   git clone <repository-url> online-shop
   cd online-shop
   ```
2. Mulai lingkungan Docker
   ```bash
   docker-compose up -d
   ```