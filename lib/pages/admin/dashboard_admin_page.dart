// ===== IMPORT LIBRARY =====
// Berisi library dan package yang dibutuhkan untuk membangun UI halaman dashboard admin
// Penting untuk mengakses widget Flutter dan warna kustom aplikasi
import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

// ===== WIDGET UTAMA =====
// Halaman dashboard admin yang menampilkan ringkasan antrian hari ini
// Penting sebagai tampilan utama untuk admin memantau status antrian apotek
class DashboardAdminPage extends StatelessWidget {
  const DashboardAdminPage({super.key});

  // ===== DATA DUMMY =====
  // Menyimpan data contoh antrian berikutnya untuk ditampilkan di dashboard
  // Penting untuk simulasi tampilan sebelum integrasi dengan backend
  static const List<Map<String, String>> _nextQueues = [
    {'kode': 'A05', 'nama': 'Siti Aminah',  'resep': 'R-882911'},
    {'kode': 'A06', 'nama': 'Ahmad Dhani',  'resep': 'R-882912'},
    {'kode': 'A07', 'nama': 'Lina Marlina', 'resep': 'R-882913'},
  ];
  // ===== PEMBANGUN UI =====
  // Membangun tampilan utama dashboard dengan berbagai kartu informasi
  // Penting untuk menampilkan ringkasan antrian secara visual dan terstruktur
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _buildTodayCard(),
          const SizedBox(height: 16),
          IntrinsicHeight(child: Row(children: [
            Expanded(child: _buildStatusCard('BELUM DI PANGGIL', '5', AppColors.warning, Icons.hourglass_bottom_rounded)),
            const SizedBox(width: 12),
            Expanded(child: _buildStatusCard('SELESAI', '2', AppColors.teal, Icons.check_circle_outline_rounded)),
          ])),
          const SizedBox(height: 16),
          _buildCallingCard(),
          const SizedBox(height: 16),
          _buildNextSection(),
          const SizedBox(height: 16),
        ]),
      ),
    );
  }

  // ===== FUNGSI PEMBANTU UI =====
  // Membuat kartu biru besar yang menampilkan total antrian hari ini
  // Penting sebagai highlight utama dashboard untuk informasi cepat
  Widget _buildTodayCard() => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: AppColors.primary,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4))],
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
      const Text('ANTRIAN HARI INI', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.lightCyan, letterSpacing: 1.1)),
      const SizedBox(height: 4),
      RichText(text: const TextSpan(children: [
        TextSpan(text: '8', style: TextStyle(fontFamily: 'Poppins', fontSize: 40, fontWeight: FontWeight.w700, color: Colors.white)),
        TextSpan(text: '\u2003\u2003Pasien', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, color: AppColors.lightCyan)),
      ])),
    ]),
  );

  // Membuat kartu kecil untuk menampilkan status antrian (belum dipanggil/selesai)
  // Penting untuk memberikan ringkasan visual status antrian secara cepat
  Widget _buildStatusCard(String title, String count, Color color, IconData icon) => Container(
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.border, width: 1),
      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), offset: const Offset(0, 4), blurRadius: 8)],
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
      Row(children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 6),
        Expanded(child: Text(title, style: const TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.slateGrey), overflow: TextOverflow.ellipsis)),
      ]),
      const SizedBox(height: 8),
      Text(count, style: const TextStyle(fontFamily: 'Poppins', fontSize: 26, fontWeight: FontWeight.w400, color: AppColors.textDark)),
    ]),
  );

  // Membuat kartu yang menampilkan antrian yang sedang dipanggil saat ini
  // Penting untuk menunjukkan pasien mana yang sedang dilayani
  Widget _buildCallingCard() => Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 20, offset: const Offset(0, 10))],
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const Text('SEDANG DIPANGGIL', style: TextStyle(fontFamily: 'Poppins', color: AppColors.teal, fontWeight: FontWeight.w400, fontSize: 18, letterSpacing: 0.5)),
        Container(width: 10, height: 10, decoration: const BoxDecoration(color: AppColors.mintDark, shape: BoxShape.circle)),
      ]),
      const SizedBox(height: 12),
      const Text('A04', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.textDark, height: 1.1)),
      const SizedBox(height: 16),
      Container(
        padding: const EdgeInsets.only(left: 14),
        decoration: const BoxDecoration(border: Border(left: BorderSide(color: AppColors.teal, width: 4))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Budi Santoso', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.textDark)),
          const SizedBox(height: 4),
          Row(children: const [
            Icon(Icons.receipt_long_outlined, size: 16, color: AppColors.textMuted),
            SizedBox(width: 6),
            Text('ID Resep: R-882910', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, color: AppColors.textMuted)),
          ]),
        ]),
      ),
    ]),
  );

  // Membuat section yang menampilkan daftar antrian berikutnya
  // Penting untuk memberikan preview antrian yang akan dipanggil selanjutnya
  Widget _buildNextSection() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      const Text('Antrean Berikutnya', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.textDark)),
      TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
        child: const Text('Lihat Semua', style: TextStyle(fontFamily: 'Poppins', color: AppColors.teal, fontWeight: FontWeight.w600)),
      ),
    ]),
    const SizedBox(height: 4),
    ..._nextQueues.map(_buildQueueItem),
  ]);

  // Membuat item kartu untuk satu antrian dalam daftar
  // Penting untuk menampilkan detail setiap antrian secara konsisten
  Widget _buildQueueItem(Map<String, String> q) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.border),
    ),
    child: Row(children: [
      CircleAvatar(
        backgroundColor: AppColors.mint, radius: 24,
        child: Text(q['kode']!, style: const TextStyle(color: AppColors.teal, fontWeight: FontWeight.w400, fontFamily: 'Poppins')),
      ),
      const SizedBox(width: 16),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(q['nama']!, style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500, fontSize: 16, color: AppColors.textDark)),
        Text('${q['resep']} • Menunggu', style: const TextStyle(fontFamily: 'Poppins', fontSize: 16, color: AppColors.textMuted)),
      ])),
      Container(
        width: 32,
        height: 32,
        decoration: const BoxDecoration(
          color: AppColors.lightestGrey,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 20),
      ),
    ]),
  );
}