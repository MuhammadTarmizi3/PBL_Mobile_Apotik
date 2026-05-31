import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import 'tambah_obat_page.dart';
import 'edit_obat_page.dart';

// ── Model ─────────────────────────────────────────────────────────────────────
class ObatModel {
  final String id;
  final String nama;
  final String jenis;
  final int stok;
  final String satuan;
  final DateTime kadaluwarsa;
  final int hargaBeli;
  final int hargaJual;
  final IconData icon;

  const ObatModel({
    required this.id,
    required this.nama,
    required this.jenis,
    required this.stok,
    required this.satuan,
    required this.kadaluwarsa,
    required this.hargaBeli,
    required this.hargaJual,
    required this.icon,
  });

  bool get isExpiringSoon {
    final diff = kadaluwarsa.difference(DateTime.now()).inDays;
    return diff <= 90 && diff >= 0;
  }

  bool get isExpired => kadaluwarsa.isBefore(DateTime.now());

  String get expDisplay {
    final m = kadaluwarsa.month.toString().padLeft(2, '0');
    return 'EXP: $m/${kadaluwarsa.year}';
  }
}

// ── Dummy Data ────────────────────────────────────────────────────────────────
final List<ObatModel> dummyObatList = [
  ObatModel(id: '1', nama: 'Cefadroxil 500mg',   jenis: 'Antibiotik', stok: 124, satuan: 'Pcs', kadaluwarsa: DateTime(2026, 9),  hargaBeli: 8500,  hargaJual: 12500, icon: Icons.medication_rounded),
  ObatModel(id: '2', nama: 'Mylanta Cair 50ml',   jenis: 'Antasida',   stok: 45,  satuan: 'Btl', kadaluwarsa: DateTime(2025, 8),  hargaBeli: 12000, hargaJual: 18000, icon: Icons.local_drink_rounded),
  ObatModel(id: '3', nama: 'Paracetamol 500mg',   jenis: 'Analgesik',  stok: 500, satuan: 'Pcs', kadaluwarsa: DateTime(2026, 1),  hargaBeli: 1500,  hargaJual: 2500,  icon: Icons.medication_liquid_rounded),
  ObatModel(id: '4', nama: 'Amoxicillin 250mg',   jenis: 'Antibiotik', stok: 88,  satuan: 'Pcs', kadaluwarsa: DateTime(2025, 3),  hargaBeli: 5500,  hargaJual: 9000,  icon: Icons.vaccines_rounded),
  ObatModel(id: '5', nama: 'Ibuprofen 400mg',     jenis: 'Analgesik',  stok: 200, satuan: 'Pcs', kadaluwarsa: DateTime(2026, 6),  hargaBeli: 2000,  hargaJual: 3500,  icon: Icons.medication_rounded),
  ObatModel(id: '6', nama: 'Vitamin C 500mg',     jenis: 'Vitamin',    stok: 300, satuan: 'Pcs', kadaluwarsa: DateTime(2026, 12), hargaBeli: 1000,  hargaJual: 2000,  icon: Icons.local_pharmacy_rounded),
];

// ── Widget ────────────────────────────────────────────────────────────────────
class ObatAdminPage extends StatefulWidget {
  const ObatAdminPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  ObatAdminPageState createState() => ObatAdminPageState();
}

class ObatAdminPageState extends State<ObatAdminPage> {
  final _searchController = TextEditingController();
  String _selectedKategori = 'Semua';
  String _searchQuery = '';

  final _kategori = ['Semua', 'Antibiotik', 'Antasida', 'Analgesik', 'Antidiare', 'Suplemen', 'Obat Mata', 'Antitusif', 'Antipiretik', 'Vitamin'];
  final List<ObatModel> _daftarObat = List.from(dummyObatList);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ObatModel> get _filtered => _daftarObat.where((o) {
        final kMatch = _selectedKategori == 'Semua' || o.jenis == _selectedKategori;
        final sMatch = o.nama.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            o.jenis.toLowerCase().contains(_searchQuery.toLowerCase());
        return kMatch && sMatch;
      }).toList();

  String _rp(int v) {
    final s = v.toString();
    final b = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) b.write('.');
      b.write(s[i]);
    }
    return b.toString();
  }

  // Public — dipanggil FAB dari MainAdminPage
  Future<void> navigasiTambahObat() async {
    final result = await Navigator.push<ObatModel>(
      context,
      MaterialPageRoute(builder: (_) => const TambahObatAdminPage()),
    );
    if (result != null && mounted) {
      setState(() => _daftarObat.insert(0, result));
    }
  }

  Future<void> _bukaEdit(ObatModel obat) async {
    final result = await Navigator.push<ObatModel>(
      context,
      MaterialPageRoute(builder: (_) => EditObatAdminPage(obat: obat)),
    );
    if (result != null && mounted) {
      setState(() {
        final idx = _daftarObat.indexWhere((o) => o.id == result.id);
        if (idx != -1) _daftarObat[idx] = result;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final list = _filtered;
    return SafeArea(
      child: Column(
        children: [
          // Search
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _searchQuery = v),
              style: const TextStyle(fontFamily: 'Poppins', fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Cari Nama Obat',
                hintStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 14, color: AppColors.lightGrey),
                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.lightGrey),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close_rounded, color: AppColors.lightGrey, size: 18),
                        onPressed: () { _searchController.clear(); setState(() => _searchQuery = ''); },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.borderLighter)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primaryLight, width: 1.5)),
              ),
            ),
          ),

          // Filter chips
          const SizedBox(height: 16),
          SizedBox(
            height: 38,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: _kategori.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final k = _kategori[i];
                final active = _selectedKategori == k;
                return GestureDetector(
                  onTap: () => setState(() => _selectedKategori = k),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: active ? AppColors.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: active ? AppColors.primary : AppColors.borderGrey, width: 1.2),
                    ),
                    child: Text(k, style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w500, color: active ? Colors.white : AppColors.grey)),
                  ),
                );
              },
            ),
          ),

          // List
          const SizedBox(height: 8),
          Expanded(
            child: list.isEmpty
                ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.medication_outlined, size: 64, color: Colors.grey[300]),
                    const SizedBox(height: 12),
                    Text('Obat tidak ditemukan', style: TextStyle(fontFamily: 'Poppins', color: Colors.grey[400], fontSize: 14)),
                  ]))
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                    itemCount: list.length,
                    separatorBuilder: (_, __) => const Divider(height: 1, color: AppColors.border, indent: 72),
                    itemBuilder: (_, i) => _ObatTile(obat: list[i], rp: _rp, onTap: () => _bukaEdit(list[i])),
                  ),
          ),
        ],
      ),
    );
  }
}

// ── Tile ──────────────────────────────────────────────────────────────────────
class _ObatTile extends StatelessWidget {
  final ObatModel obat;
  final String Function(int) rp;
  final VoidCallback onTap;
  const _ObatTile({required this.obat, required this.rp, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final expColor = (obat.isExpired || obat.isExpiringSoon) ? Colors.red : AppColors.textMuted;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(color: AppColors.backgroundLight, borderRadius: BorderRadius.circular(10)),
              child: Icon(obat.icon, color: AppColors.teal, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(obat.nama, style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                const SizedBox(height: 3),
                Row(children: [
                  Text('Jenis: ${obat.jenis}', style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, color: AppColors.textMuted)),
                  const SizedBox(width: 12),
                  Text('Stok: ${obat.stok} ${obat.satuan}', style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, color: AppColors.textMuted)),
                ]),
                const SizedBox(height: 3),
                Row(children: [
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, color: AppColors.textMuted),
                      children: [
                        const TextSpan(text: 'Rp ', style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: AppColors.teal, fontWeight: FontWeight.w600)),
                        TextSpan(text: rp(obat.hargaJual), style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, color: AppColors.teal, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(obat.expDisplay, style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: expColor,
                      fontWeight: (obat.isExpired || obat.isExpiringSoon) ? FontWeight.w600 : FontWeight.normal)),
                ]),
              ]),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 20),
          ],
        ),
      ),
    );
  }
}