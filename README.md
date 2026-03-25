# GlowFinance 💎

**GlowFinance** adalah aplikasi manajemen keuangan pribadi (*Personal Finance Management*) yang dirancang dengan antarmuka **Modern Glass Light** yang elegan, cepat, dan sepenuhnya responsif.

## ✨ Fitur Utama
- 🔐 **Autentikasi Aman**: Registrasi & Login berbasis JWT.
- 💳 **Multi-Dompet**: Kelola saldo Kas, Bank, dan E-Wallet secara terpisah.
- 📈 **Pelacakan Transaksi**: Pemasukan, Pengeluaran, dan Transfer otomatis antar dompet.
- 📊 **Budget & Goals**: Pantau batas anggaran bulanan dan target tabungan dengan visualisasi menarik.
- 📱 **Mobile Ready**: Navigasi bawah (Bottom Nav) yang nyaman untuk penggunaan di smartphone.
- 📥 **Ekspor Data**: Unduh riwayat transaksi ke format CSV (Excel-ready).
- 🗓️ **Filter Periode**: Saring data berdasarkan bulan dan tahun spesifik.

## 🚀 Teknologi
- **Backend**: Ruby (Rack) + `eksa-server`
- **Database**: MySQL
- **Frontend**: Vanilla JS + Tailwind CSS (Glassmorphism)
- **Library**: Chart.js, Lucide Icons, JWT, BCrypt

## 🛠️ Cara Instalasi
1. Kloning repositori ini.
2. Pastikan Ruby dan MySQL sudah terunduh.
3. Instal dependensi:
   ```bash
   bundle install
   ```
4. Salin `.env.example` ke `.env` dan sesuaikan konfigurasi database.
5. Impor skema database dari `db/schema.sql`.
6. Jalankan server:
   ```bash
   bundle exec eksa-server
   ```
7. Akses `http://localhost:3000` di browser Anda.

## 📄 Lisensi
Proyek ini dilisensikan di bawah **MIT License**. Lihat file `LICENSE` untuk detail lebih lanjut.