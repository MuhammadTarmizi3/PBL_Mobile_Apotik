import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

/// Konten tab Profile — AppBar & BottomNav dikelola MainPetugasPage.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 24),
            _buildInfoSection(),
            const SizedBox(height: 32),
            _buildLogoutButton(context),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        const SizedBox(height: 16),
        Container(
          width: 96, height: 96,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.surface, width: 3),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 12, offset: const Offset(0, 4))],
            image: const DecorationImage(image: NetworkImage('https://i.pravatar.cc/150?img=26'), fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: 14),
        const Text('Mutia Amelia', style: TextStyle(fontFamily: 'Poppins', fontSize: 17, fontWeight: FontWeight.w600, color: AppColors.textDark)),
        const SizedBox(height: 4),
        const Text('Petugas Apotik', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.primaryLight)),
      ],
    );
  }

  Widget _buildInfoSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Informasi Pribadi', style: TextStyle(fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textDark)),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
            ),
            child: Column(
              children: [
                _infoRow(icon: Icons.email_outlined,  label: 'EMAIL',         value: 'mutia.amelia@viamedika.com', divider: true),
                _infoRow(icon: Icons.phone_outlined,  label: 'NOMOR TELEPON', value: '+62 812-3456-7890',          divider: true),
                _infoRow(icon: Icons.badge_outlined,  label: 'ID PEGAWAI',    value: 'APT-PTG-001',                divider: false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow({required IconData icon, required String label, required String value, required bool divider}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 42, height: 42,
                decoration: BoxDecoration(color: const Color(0xFFF0F0F0), borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, color: const Color(0xFF555555), size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF888888), letterSpacing: 0.5)),
                    const SizedBox(height: 2),
                    Text(value, style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textDark)),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (divider) const Divider(height: 1, thickness: 1, indent: 72, color: Color(0xFFF0F0F0)),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton.icon(
          onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false),
          icon: const Icon(Icons.logout_rounded, color: Colors.white, size: 20),
          label: const Text('Keluar', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.danger,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ),
    );
  }
}