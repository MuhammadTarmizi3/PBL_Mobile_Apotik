import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import 'detail_eresep_page.dart';

/// Konten tab E-Resep — AppBar & BottomNav dikelola MainPetugasPage.
class EResepPage extends StatelessWidget {
  const EResepPage({super.key});

  static final List<Map<String, dynamic>> _resepList = [
    {'nomor': '001', 'items': ['1x Mylanta Cair 50ml', '1x Paracetamol']},
    {'nomor': '002', 'items': ['1x Sangobion', '1x Enervon-C']},
    {'nomor': '003', 'items': ['1x Sangobion', '1x Cefadroxil 500mg']},
    {'nomor': '004', 'items': ['1x Sangobion', '1x Cefadroxil 500mg', '1x Enervon-C', '1x Diapet']},
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        itemCount: _resepList.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) => _buildResepCard(context, _resepList[index]),
      ),
    );
  }

  Widget _buildResepCard(BuildContext context, Map<String, dynamic> resep) {
    final String nomor       = resep['nomor'] as String;
    final List<String> items = List<String>.from(resep['items'] as List);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Badge nomor antrian
                Container(
                  width: 56, height: 56,
                  decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8)),
                  alignment: Alignment.center,
                  child: Text(nomor, style: const TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Resep', style: TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A))),
                      const SizedBox(height: 4),
                      ...items.map((item) => Text(item, style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Color(0xFF555555), height: 1.6))),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => DetailEResepPage(resep: resep)),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Pilih', style: TextStyle(fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}