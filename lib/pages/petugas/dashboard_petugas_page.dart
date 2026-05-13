import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

/// Hanya konten Dashboard — AppBar & BottomNav dikelola MainPetugasPage.
class DashboardPetugasPage extends StatelessWidget {
  const DashboardPetugasPage({super.key});

  static const Color _darkTeal = AppColors.primary;
  static const Color _teal     = Color(0xFF249E94);
  static const Color _mint     = Color(0xFF3BC1A8);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTodayQueueCard(),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _buildSmallStatusCard('BELUM DI PANGGIL', '5', const Color(0xFFF4A640), Icons.hourglass_bottom_rounded)),
                const SizedBox(width: 12),
                Expanded(child: _buildSmallStatusCard('SELESAI', '2', _teal, Icons.check_circle_outline_rounded)),
              ],
            ),
            const SizedBox(height: 8),
            _buildCallingCard(),
            const SizedBox(height: 8),
            _buildNextQueueSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayQueueCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _darkTeal,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('ANTRIAN HARI INI', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white70, letterSpacing: 1.1)),
          const SizedBox(height: 4),
          RichText(
            text: const TextSpan(children: [
              TextSpan(text: '8 ', style: TextStyle(fontFamily: 'Poppins', fontSize: 40, fontWeight: FontWeight.w700, color: Colors.white)),
              TextSpan(text: 'Pasien', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, color: Colors.white)),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallStatusCard(String title, String count, Color color, IconData icon) {
    return Container(
      height: 86,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF0F0F0), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 4),
            Text(title, style: TextStyle(fontFamily: 'Poppins', fontSize: 10, fontWeight: FontWeight.w600, color: Colors.grey[600])),
          ]),
          const Spacer(),
          Text(count, style: const TextStyle(fontFamily: 'Poppins', fontSize: 24, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _buildCallingCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('SEDANG DIPANGGIL', style: TextStyle(fontFamily: 'Poppins', color: _teal, fontWeight: FontWeight.bold, fontSize: 12)),
              Container(width: 10, height: 10, decoration: const BoxDecoration(color: _mint, shape: BoxShape.circle)),
            ],
          ),
          const SizedBox(height: 3.5),
          const Text('A04', style: TextStyle(fontFamily: 'Poppins', fontSize: 32, fontWeight: FontWeight.bold)),
          const SizedBox(height: 3.5),
          const Text('Budi Santoso', style: TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.w500)),
          const SizedBox(height: 3.5),
          const Text('ID Resep: R-882910', style: TextStyle(fontFamily: 'Poppins', color: Colors.grey)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primaryLight, width: 1),
                      backgroundColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.refresh_rounded, color: AppColors.primaryLight, size: 17.5),
                        SizedBox(width: 15),
                        Text('Panggil Ulang', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, color: AppColors.primaryLight, height: 1.5)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.danger,
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                    child: const Text('Skip', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, color: Colors.white, height: 1.5)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.done_all_rounded, color: Colors.white),
              label: const Text('Selesai & Lanjut', style: TextStyle(fontFamily: 'Poppins', color: Colors.white, fontSize: 16, height: 1.5)),
              style: ElevatedButton.styleFrom(
                backgroundColor: _darkTeal,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextQueueSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Antrean Berikutnya', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w600)),
            Text('Lihat Semua', style: TextStyle(fontFamily: 'Poppins', color: _teal, fontWeight: FontWeight.w500)),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFF0F0F0))),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: _teal.withOpacity(0.1),
                child: const Text('A05', style: TextStyle(color: _teal, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Siti Aminah', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500)),
                  Text('R-882911 • Menunggu', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.grey)),
                ],
              ),
              const Spacer(),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ],
    );
  }
}