// ===== IMPORT LIBRARY =====
// Bagian ini berisi import library yang dibutuhkan untuk halaman detail antrian
// Penting untuk mengakses komponen UI dan model data

// Import library Flutter untuk komponen UI
import 'package:flutter/material.dart';
// Import konfigurasi warna aplikasi
import '../../utils/app_colors.dart';
// Import model Antrian dari halaman dashboard petugas
import 'dashboard_petugas_page.dart';

// ===== WIDGET UTAMA =====
// Bagian ini mendefinisikan widget utama halaman detail antrian
// Penting sebagai halaman untuk melihat detail informasi antrian pasien

// Widget halaman detail antrian (StatelessWidget karena tidak ada perubahan state)
class DetailAntrianPage extends StatelessWidget {
  final Antrian antrian; // Data antrian yang diterima dari halaman sebelumnya

  const DetailAntrianPage({
    super.key,
    required this.antrian,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundMint,

      // ── APP BAR ──
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Detail Antrian',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: AppColors.textDark,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: false,
        shape: const Border(bottom: BorderSide(color: AppColors.border)),
      ),

      // ── TOMBOL BAWAH (SELESAIKAN) — sticky di bawah layar ──
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(
          20, 16, 20, 16 + MediaQuery.of(context).padding.bottom,
        ),
        decoration: const BoxDecoration(
          color: AppColors.backgroundMint,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: SizedBox(
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              // TODO: Tambahkan aksi penyelesaian antrian di sini
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.save, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text(
                  'Selesaikan',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      // ── KONTEN UTAMA ──
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── KARTU HEADER PASIEN ──
            // Menampilkan nomor antrian, nama pasien, dan ID resep
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  // Lingkaran nomor antrian
                  CircleAvatar(
                    backgroundColor: AppColors.mint,
                    radius: 28,
                    child: Text(
                      antrian.nomor,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        color: AppColors.teal,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Nama dan ID Resep
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          antrian.nama,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'R-${antrian.idResep}',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── LABEL STATUS ──
            const Text(
              'Status',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),

            // Badge status dengan warna dinamis berdasarkan status antrian
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: _getStatusColor(antrian.status),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _getStatusLabel(antrian.status),
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── DETAIL RESEP ──
            const Text(
              'Detail',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'ID Resep: R-${antrian.idResep}',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),

            // Kartu daftar obat (Mock Data sementara)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  // Daftar obat (Data statis sementara)
                  Text(
                    '1x Sangobion',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      color: AppColors.tealMedium,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '1x Cefadroxil 500mg',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      color: AppColors.tealMedium,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── FUNGSI PEMBANTU ──────────────────────────────────────────────────────────

  // Mengembalikan warna badge sesuai status antrian
  Color _getStatusColor(String status) {
    switch (status) {
      case 'dipanggil':
        return AppColors.teal;
      case 'menunggu':
        return AppColors.warning;
      case 'skip':
        return const Color(0xFFFF8A8A); // Merah soft sesuai desain
      case 'selesai':
        return AppColors.primaryLight;
      default:
        return AppColors.textMuted;
    }
  }

  // Mengembalikan label teks sesuai status antrian
  String _getStatusLabel(String status) {
    switch (status) {
      case 'dipanggil':
        return 'Dipanggil';
      case 'menunggu':
        return 'Menunggu';
      case 'skip':
        return 'Skip';
      case 'selesai':
        return 'Selesai';
      default:
        return status;
    }
  }
}
