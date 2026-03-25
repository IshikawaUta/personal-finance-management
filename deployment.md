# Panduan Deployment GlowFinance 🚀

Aplikasi ini dirancang untuk berjalan di **Railway.app**. Berikut adalah ringkasan langkah deployment-nya:

## 1. File Penting
- **Procfile**: Menjalankan server `eksa-server`.
- **.env.example**: Panduan variabel lingkungan yang dibutuhkan.
- **db/schema.sql**: Skema database MySQL.

## 2. Struktur di Railway (Satu Projek)
Gabungkan layanan berikut dalam satu projek yang sama:
1. **Layanan Ruby**: Hubungkan ke GitHub Anda.
2. **Layanan MySQL**: Tambahkan via `+ New > Database`.
3. **Layanan phpMyAdmin**: Tambahkan via `+ New > Docker Image` menggunakan image: **`linuxserver/phpmyadmin:latest`**.

## 3. Variabel Lingkungan (Environment Variables)
Tambahkan variabel berikut pada **Layanan Ruby** Anda:
- `DB_HOST`: `${{MySQL.MYSQLHOST}}`
- `DB_PORT`: `${{MySQL.MYSQLPORT}}`
- `DB_USER`: `${{MySQL.MYSQLUSER}}`
- `DB_PASS`: `${{MySQL.MYSQLPASSWORD}}`
- `DB_NAME`: `${{MySQL.MYSQLDATABASE}}`
- `JWT_SECRET`: (Gunakan kunci rahasia Anda)

### Variabel phpMyAdmin (Layanan Monitoring)
Tambahkan pada **Layanan phpMyAdmin** Anda:
- `PMA_HOST`: `${{MySQL.MYSQLHOST}}`
- `PMA_USER`: `${{MySQL.MYSQLUSER}}`
- `PMA_PASSWORD`: `${{MySQL.MYSQLPASSWORD}}`
- `PORT`: `80`

## 4. Inisialisasi Database
Ada dua cara untuk memasukkan tabel dari `db/schema.sql`:

### A. Via Tab "Data" (Rekomendasi)
1. Klik layanan **MySQL** di Railway.
2. Ke tab **Data** > **Queries**.
3. Salin isi `db/schema.sql` dan **Run**.

### B. Via phpMyAdmin
1. Akses URL phpMyAdmin Anda.
2. Login dengan `MYSQLUSER` & `MYSQLPASSWORD`.
3. Pilih database di kiri, klik tab **Import**, pilih file `db/schema.sql` di komputer, dan klik **Go**.