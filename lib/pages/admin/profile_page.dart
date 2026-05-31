// ===== IMPORT LIBRARY =====
// Berisi library Flutter dan file warna kustom untuk membangun UI profil admin
// Penting untuk mengakses widget dan styling yang konsisten
import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

// ===== WIDGET UTAMA =====
// Halaman profil admin yang menampilkan informasi pribadi dan tombol logout
// Penting untuk mengelola identitas dan sesi pengguna admin
class ProfileAdminPage extends StatelessWidget {
  const ProfileAdminPage({super.key});

  // ===== PEMBANGUN UI =====
  // Membangun tampilan halaman profil dengan foto, info pribadi, dan tombol logout
  // Penting untuk menampilkan identitas admin dan opsi keluar aplikasi
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundMint,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          'Profile',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        shape: const Border(
          bottom: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildInfoSection(),
            const SizedBox(height: 32),
            _buildLogoutButton(context),
            const SizedBox(height: 24),
          ]),
        ),
      ),
    );
  }

  // ===== FUNGSI PEMBANTU UI =====
  // Membuat header profil dengan foto, nama, dan jabatan admin
  // Penting untuk identifikasi visual pengguna yang sedang login
  Widget _buildHeader() => Column(children: [
    const SizedBox(height: 16),
    Container(
      width: 96, height: 96,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.surface, width: 3),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 12, offset: const Offset(0, 4))],
        image: const DecorationImage(image: NetworkImage('https://i.pravatar.cc/150?img=26'), fit: BoxFit.cover),
      ),
    ),
    const SizedBox(height: 14),
    const Text('Admin Viamedika', style: TextStyle(fontFamily: 'Poppins', fontSize: 17, fontWeight: FontWeight.w600, color: AppColors.textDark)),
    const SizedBox(height: 4),
    const Text('Administrator', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.primaryLight)),
  ]);

  // Membuat section informasi pribadi dengan email, telepon, dan ID admin
  // Penting untuk menampilkan detail kontak dan identitas admin
  Widget _buildInfoSection() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Informasi Pribadi', style: TextStyle(fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textDark)),
      const SizedBox(height: 12),
      Container(
        decoration: BoxDecoration(
          color: AppColors.surface, borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Column(children: [
          _infoRow(icon: Icons.email_outlined,   label: 'EMAIL',         value: 'admin@viamedika.com',  divider: true),
          _infoRow(icon: Icons.phone_outlined,   label: 'NOMOR TELEPON', value: '+62 811-2345-6789',    divider: true),
          _infoRow(icon: Icons.badge_outlined,   label: 'ID ADMIN',      value: 'APT-ADM-001',          divider: false),
        ]),
      ),
    ]),
  );

  Widget _infoRow({required IconData icon, required String label, required String value, required bool divider}) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(children: [
          Container(
            width: 42, height: 42,
            decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: AppColors.grey, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textMuted, letterSpacing: 0.5)),
            const SizedBox(height: 2),
            Text(value, style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textDark)),
          ])),
        ]),
      ),
      if (divider) const Divider(height: 1, thickness: 1, indent: 72, color: AppColors.border),
    ]);
  }

  Widget _buildLogoutButton(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: SizedBox(
      width: double.infinity, height: 52,
      child: ElevatedButton.icon(
        onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false),
        icon: const Icon(Icons.logout_rounded, color: Colors.white, size: 20),
        label: const Text('Keluar', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      ),
    ),
  );
}