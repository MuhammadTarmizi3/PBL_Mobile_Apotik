import 'package:flutter/material.dart';

class DetailEResepPage extends StatefulWidget {
  /// Data resep diteruskan dari EResepPage saat tombol "Pilih" ditekan.
  final Map<String, dynamic> resep;

  const DetailEResepPage({super.key, required this.resep});

  @override
  State<DetailEResepPage> createState() => _DetailEResepPageState();
}

class _DetailEResepPageState extends State<DetailEResepPage> {
  static const Color _darkTeal = Color(0xFF005461);
  static const Color _teal     = Color(0xFF249E94);
  static const Color _red      = Color(0xFFB91C1C);

  bool _berhasil    = false;
  bool _tidakSesuai = false;

  final List<Map<String, dynamic>> _daftarObat = [
    {'id': '#0001', 'nama': 'Cefadroxil 500mg',  'kategori': 'Antibiotik', 'exp': '2027-05-01', 'stok': 80,  'qty': 0},
    {'id': '#0002', 'nama': 'Mylanta Cair 50ml',  'kategori': 'Antasida',   'exp': '2026-07-07', 'stok': 45,  'qty': 0},
    {'id': '#0003', 'nama': 'Bodrex Migra',        'kategori': 'Analgesik',  'exp': '2026-12-15', 'stok': 65,  'qty': 0},
    {'id': '#0004', 'nama': 'Paracetamol 500mg',   'kategori': 'Analgesik',  'exp': '2027-01-20', 'stok': 120, 'qty': 0},
    {'id': '#0005', 'nama': 'Sangobion',            'kategori': 'Suplemen',   'exp': '2027-03-10', 'stok': 60,  'qty': 0},
    {'id': '#0006', 'nama': 'Enervon-C',            'kategori': 'Suplemen',   'exp': '2026-11-30', 'stok': 90,  'qty': 0},
    {'id': '#0007', 'nama': 'Diapet',               'kategori': 'Antidiare',  'exp': '2026-09-15', 'stok': 75,  'qty': 0},
  ];

  // ── Helpers ─────────────────────────────────────────────────────────────────

  void _increment(int index) {
    final int stok = _daftarObat[index]['stok'] as int;
    final int qty  = _daftarObat[index]['qty']  as int;
    if (qty < stok) setState(() => _daftarObat[index]['qty'] = qty + 1);
  }

  void _decrement(int index) {
    final int qty = _daftarObat[index]['qty'] as int;
    if (qty > 0) setState(() => _daftarObat[index]['qty'] = qty - 1);
  }

  /// Validasi: setiap item dalam resep harus ada padanannya di daftar obat
  /// dengan qty > 0. Pencocokan berdasarkan nama obat (case-insensitive).
  bool _isSesuai() {
    final List<String> items = List<String>.from(widget.resep['items'] as List);
    for (final item in items) {
      final String keyword = item.replaceFirst(RegExp(r'^\d+x\s*'), '').toLowerCase().trim();
      final bool ada = _daftarObat.any(
        (o) => (o['nama'] as String).toLowerCase().contains(keyword) && (o['qty'] as int) > 0,
      );
      if (!ada) return false;
    }
    return true;
  }

  void _onSimpan() {
    if (_isSesuai()) {
      setState(() { _berhasil = true; _tidakSesuai = false; });
    } else {
      setState(() { _tidakSesuai = true; _berhasil = false; });
    }
  }

  // ── Build ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          // ── Konten utama
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionLabel('RESEP TERPILIH'),
                      const SizedBox(height: 8),
                      _buildResepTerpilihCard(),
                      const SizedBox(height: 20),
                      _sectionLabel('DAFTAR OBAT (LIST OBAT)'),
                      if (_tidakSesuai) ...[
                        const SizedBox(height: 6),
                        const Text(
                          'RESEP TIDAK SESUAI',
                          style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFFB91C1C), letterSpacing: 0.4),
                        ),
                      ],
                      const SizedBox(height: 8),
                      ..._daftarObat.asMap().entries.map(
                        (e) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildObatCard(e.key, e.value),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _buildBottomActions(),
            ],
          ),

          // ── Overlay sukses
          if (_berhasil)
            Positioned.fill(
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  color: Colors.black.withOpacity(0.45),
                  child: Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 32),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
                      decoration: BoxDecoration(color: const Color(0xFFF0F0F0), borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 80, height: 80,
                            decoration: const BoxDecoration(color: Color(0xFF005461), shape: BoxShape.circle),
                            child: const Icon(Icons.check_rounded, color: Colors.white, size: 48),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'RESEP BERHASIL\nDI PROSES',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontFamily: 'Poppins', fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF1A1A1A), height: 1.4),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Ketuk di mana saja untuk kembali',
                            style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Color(0xFF888888)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ── Widgets ──────────────────────────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1A1A)),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text('E-Resep', style: TextStyle(fontFamily: 'Poppins', fontSize: 17, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A))),
      shape: const Border(bottom: BorderSide(color: Color(0xFFF0F0F0), width: 1)),
    );
  }

  Widget _sectionLabel(String label) {
    return Text(label, style: TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey[500], letterSpacing: 0.8));
  }

  Widget _buildResepTerpilihCard() {
    final String nomor       = widget.resep['nomor'] as String;
    final List<String> items = List<String>.from(widget.resep['items'] as List);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52, height: 52,
            decoration: BoxDecoration(color: _darkTeal, borderRadius: BorderRadius.circular(8)),
            alignment: Alignment.center,
            child: Text(nomor, style: const TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Resep', style: TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.w700, color: _teal)),
                const SizedBox(height: 4),
                ...items.map((item) => Text(item, style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: _teal, height: 1.6))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildObatCard(int index, Map<String, dynamic> obat) {
    final int qty  = obat['qty']  as int;
    final int stok = obat['stok'] as int;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: _teal.withOpacity(0.12), borderRadius: BorderRadius.circular(6)),
                child: Text(obat['id'] as String, style: TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w600, color: _teal)),
              ),
              Text('Stok: $stok', style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Color(0xFF888888))),
            ],
          ),
          const SizedBox(height: 6),
          Text(obat['nama'] as String, style: const TextStyle(fontFamily: 'Poppins', fontSize: 17, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A))),
          Text(obat['kategori'] as String, style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Color(0xFF888888))),
          const SizedBox(height: 8),
          Row(children: [
            const Icon(Icons.calendar_today_outlined, size: 14, color: Color(0xFF888888)),
            const SizedBox(width: 5),
            Text('Exp: ${obat['exp']}', style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Color(0xFF888888))),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            GestureDetector(
              onTap: () => _decrement(index),
              child: Icon(Icons.remove_circle_outline_rounded, size: 28, color: qty > 0 ? _red : Colors.grey[300]),
            ),
            const SizedBox(width: 16),
            Text('$qty', style: const TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A))),
            const SizedBox(width: 16),
            GestureDetector(
              onTap: () => _increment(index),
              child: Icon(Icons.add_circle_outline_rounded, size: 28, color: qty < stok ? _teal : Colors.grey[300]),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: _onSimpan,
              icon: const Icon(Icons.save_rounded, color: Colors.white, size: 20),
              label: const Text('Simpan', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: _darkTeal,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: _red,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Batal', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}