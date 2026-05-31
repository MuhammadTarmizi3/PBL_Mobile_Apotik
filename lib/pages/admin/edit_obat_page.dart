// ===== IMPORT LIBRARY =====
// Bagian ini berisi import library yang dibutuhkan untuk halaman edit obat
// Penting untuk mengakses komponen UI, validasi input, dan model data

// Import library Flutter untuk komponen UI
import 'package:flutter/material.dart';
// Import library untuk formatter input (hanya angka, dll)
import 'package:flutter/services.dart';
// Import konfigurasi warna aplikasi
import '../../utils/app_colors.dart';
// Import model ObatModel dari halaman obat
import 'obat_page.dart';

// ===== WIDGET UTAMA =====
// Bagian ini mendefinisikan widget utama halaman edit obat
// Penting sebagai form untuk mengubah data obat yang sudah ada

// Widget halaman edit obat dengan form input
class EditObatAdminPage extends StatefulWidget {
  final ObatModel obat; // Data obat yang akan diedit
  const EditObatAdminPage({super.key, required this.obat});

  @override
  State<EditObatAdminPage> createState() => _EditObatAdminPageState();
}

class _EditObatAdminPageState extends State<EditObatAdminPage> {
  // ===== VARIABEL STATE =====
  // Bagian ini berisi variabel-variabel yang menyimpan state form edit obat
  // Penting untuk mengelola input user dan validasi form
  
  // Key untuk validasi form
  final _formKey = GlobalKey<FormState>();
  // Controller untuk setiap input field
  late final TextEditingController _namaCtrl;
  late final TextEditingController _jenisCtrl;
  late final TextEditingController _stokCtrl;
  late final TextEditingController _hargaBeliCtrl;
  late final TextEditingController _hargaJualCtrl;
  // Variabel untuk menyimpan tanggal kadaluwarsa yang dipilih
  late DateTime _selectedDate;
  // State loading saat proses simpan
  bool _loading = false;

  // State untuk popup overlay sukses
  bool _berhasil = false;
  bool _siapTutupPopup = false;
  ObatModel? _updatedObat; // Menyimpan hasil edit untuk dikirim saat popup ditutup

  // ===== METODE LIFECYCLE =====
  // Bagian ini berisi method lifecycle Flutter
  // Penting untuk inisialisasi data dan cleanup resources
  
  // Method initState dipanggil sekali saat widget pertama kali dibuat
  @override
  void initState() {
    super.initState();
    final o = widget.obat;
    // Inisialisasi controller dengan data obat yang akan diedit
    _namaCtrl      = TextEditingController(text: o.nama);
    _jenisCtrl     = TextEditingController(text: o.jenis);
    _stokCtrl      = TextEditingController(text: o.stok.toString());
    _hargaBeliCtrl = TextEditingController(text: o.hargaBeli.toString());
    _hargaJualCtrl = TextEditingController(text: o.hargaJual.toString());
    _selectedDate  = o.kadaluwarsa;
  }

  // Method dispose untuk membersihkan controller saat widget dihapus
  @override
  void dispose() {
    _namaCtrl.dispose(); _jenisCtrl.dispose(); _stokCtrl.dispose();
    _hargaBeliCtrl.dispose(); _hargaJualCtrl.dispose();
    super.dispose();
  }

  // ===== FUNGSI PEMBANTU =====
  // Bagian ini berisi fungsi-fungsi helper untuk interaksi user
  // Penting untuk menangani pemilihan tanggal dan format data
  
  // Fungsi untuk membuka date picker dan memilih tanggal kadaluwarsa
  // Fungsi untuk membuka date picker dan memilih tanggal kadaluwarsa
  Future<void> _pickDate() async {
    final now = DateTime.now();
    final p = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 10),
      builder: (c, child) => Theme(
        data: Theme.of(c).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.primary,
            onPrimary: Colors.white,
            surface: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (p != null) setState(() => _selectedDate = p);
  }

  // Fungsi untuk memformat tanggal ke format DD/MM/YYYY
  String _fmt(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  // Fungsi untuk menyimpan perubahan data obat dengan overlay sukses
  void _simpan() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;

    _updatedObat = ObatModel(
      id: widget.obat.id,
      nama: _namaCtrl.text.trim(),
      jenis: _jenisCtrl.text.trim(),
      stok: int.tryParse(_stokCtrl.text) ?? 0,
      satuan: widget.obat.satuan,
      kadaluwarsa: _selectedDate,
      hargaBeli: int.tryParse(_hargaBeliCtrl.text) ?? 0,
      hargaJual: int.tryParse(_hargaJualCtrl.text) ?? 0,
      icon: widget.obat.icon,
    );

    setState(() {
      _loading = false;
      _berhasil = true;        // Munculkan overlay
      _siapTutupPopup = false; // Guard: jangan langsung tertutup oleh tap Simpan
    });

    // Aktifkan penutupan popup setelah frame tap Simpan selesai
    Future.delayed(const Duration(milliseconds: 180), () {
      if (!mounted || !_berhasil) return;
      setState(() => _siapTutupPopup = true);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Edit Data Obat',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        shape: const Border(bottom: BorderSide(color: AppColors.border)),
      ),

      // ── Tombol Simpan & Batal tetap di bawah layar (sticky) ───────────────
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + MediaQuery.of(context).padding.bottom),
        decoration: BoxDecoration(
          color: AppColors.backgroundLight,
          border: const Border(top: BorderSide(color: AppColors.border)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _btn(
              label: 'Simpan',
              icon: Icons.save_rounded,
              color: AppColors.primary,
              onTap: _loading ? null : _simpan,
              loading: _loading,
            ),
            const SizedBox(height: 12),
            _btn(label: 'Batal', color: AppColors.danger, onTap: () => Navigator.pop(context)),
          ],
        ),
      ),

      // ── Stack: Konten utama + Overlay sukses di atasnya ───────────────────
      body: Stack(
        children: [
          // ── LAPISAN BAWAH: Form utama
          Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                // Grup 1
                _Card(children: [
                  _field(label: 'NAMA OBAT', ctrl: _namaCtrl, hint: 'Masukkan Nama Obat'),
                  const SizedBox(height: 16),
                  _field(label: 'JENIS', ctrl: _jenisCtrl, hint: 'Masukkan Jenis'),
                  const SizedBox(height: 16),
                  _field(
                    label: 'STOK',
                    ctrl: _stokCtrl,
                    hint: 'Masukkan Stok',
                    type: TextInputType.number,
                    fmt: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  const SizedBox(height: 16),
                  _dateField(),
                ]),
                const SizedBox(height: 12),
                // Grup 2
                _Card(children: [
                  _currField(label: 'HARGA BELI', ctrl: _hargaBeliCtrl, hint: 'Masukkan Harga Beli'),
                  const SizedBox(height: 16),
                  _currField(label: 'HARGA JUAL', ctrl: _hargaJualCtrl, hint: 'Masukkan Harga Jual'),
                ]),
                const SizedBox(height: 16),
              ]),
            ),
          ),

          // ── LAPISAN ATAS: Overlay sukses (sama persis seperti DetailEResepPage)
          if (_berhasil)
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  // Guard: abaikan tap pertama dari tombol Simpan
                  if (!_siapTutupPopup) return;
                  Navigator.pop(context, _updatedObat);
                },
                child: Container(
                  color: Colors.black.withValues(alpha: 0.45),
                  child: Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 32),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Lingkaran hijau centang
                          Container(
                            width: 80,
                            height: 80,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check_rounded,
                              color: Colors.white,
                              size: 48,
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'DATA OBAT\nBERHASIL\nDIPERBARUI',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textDark,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Ketuk di mana saja untuk kembali',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              color: AppColors.textMuted,
                            ),
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

  // ── Helpers ─────────────────────────────────────────────────────────────────

  Widget _field({
    required String label,
    required TextEditingController ctrl,
    required String hint,
    TextInputType type = TextInputType.text,
    List<TextInputFormatter>? fmt,
  }) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _lbl(label),
      const SizedBox(height: 8),
      TextFormField(
        controller: ctrl,
        keyboardType: type,
        inputFormatters: fmt,
        validator: (v) => (v == null || v.isEmpty) ? 'Wajib diisi' : null,
        style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, color: AppColors.textDark),
        decoration: _deco(hint),
      ),
    ]);
  }

  Widget _currField({
    required String label,
    required TextEditingController ctrl,
    required String hint,
  }) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _lbl(label),
      const SizedBox(height: 8),
      TextFormField(
        controller: ctrl,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        validator: (v) => (v == null || v.isEmpty) ? 'Wajib diisi' : null,
        style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, color: AppColors.textDark),
        decoration: _deco(hint).copyWith(
          prefixText: 'Rp  ',
          prefixStyle:
              const TextStyle(fontFamily: 'Poppins', fontSize: 14, color: AppColors.textMuted),
        ),
      ),
    ]);
  }

  Widget _dateField() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _lbl('TANGGAL KADALUWARSA'),
      const SizedBox(height: 8),
      GestureDetector(
        onTap: _pickDate,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              _fmt(_selectedDate),
              style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, color: AppColors.textDark),
            ),
            const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textMuted),
          ]),
        ),
      ),
    ]);
  }

  Widget _btn({
    required String label,
    IconData? icon,
    required Color color,
    VoidCallback? onTap,
    bool loading = false,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          if (loading) ...[
            const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)),
            const SizedBox(width: 10),
          ] else if (icon != null) ...[
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
          ],
          Text(
            loading ? 'Menyimpan...' : label,
            style: const TextStyle(
                fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ]),
      ),
    );
  }

  Widget _lbl(String t) => Text(
        t,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.textMuted,
          letterSpacing: 0.5,
        ),
      );

  InputDecoration _deco(String hint) => InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 14, color: AppColors.lightGrey),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.borderLight)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.primaryLight, width: 1.5)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.danger)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.danger, width: 1.5)),
      );
}

// ── Reusable Card ─────────────────────────────────────────────────────────────
class _Card extends StatelessWidget {
  final List<Widget> children;
  const _Card({required this.children});

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2))
          ],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
      );
}