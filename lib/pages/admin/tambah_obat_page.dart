import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/app_colors.dart';
import 'obat_page.dart';

class TambahObatAdminPage extends StatefulWidget {
  const TambahObatAdminPage({super.key});

  @override
  State<TambahObatAdminPage> createState() => _TambahObatAdminPageState();
}

class _TambahObatAdminPageState extends State<TambahObatAdminPage> {
  final _formKey       = GlobalKey<FormState>();
  final _namaCtrl      = TextEditingController();
  final _jenisCtrl     = TextEditingController();
  final _stokCtrl      = TextEditingController();
  final _hargaBeliCtrl = TextEditingController();
  final _hargaJualCtrl = TextEditingController();
  DateTime? _selectedDate;
  bool _loading = false;

  // ── State pop-up overlay (sama seperti DetailEResepPage) ──────────────────
  bool _berhasil = false;
  bool _siapTutupPopup = false;
  ObatModel? _obatBaru; // Menyimpan hasil tambah untuk dikirim saat popup ditutup

  @override
  void dispose() {
    _namaCtrl.dispose(); _jenisCtrl.dispose(); _stokCtrl.dispose();
    _hargaBeliCtrl.dispose(); _hargaJualCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final p = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(now.year + 1, now.month),
      firstDate: now,
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

  String _fmt(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  // ── Simpan dengan overlay sukses (logika sama seperti DetailEResepPage) ────
  void _simpan() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Pilih tanggal kadaluwarsa',
            style: TextStyle(fontFamily: 'Poppins')),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ));
      return;
    }

    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;

    _obatBaru = ObatModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      nama: _namaCtrl.text.trim(),
      jenis: _jenisCtrl.text.trim(),
      stok: int.tryParse(_stokCtrl.text) ?? 0,
      satuan: 'Pcs',
      kadaluwarsa: _selectedDate!,
      hargaBeli: int.tryParse(_hargaBeliCtrl.text) ?? 0,
      hargaJual: int.tryParse(_hargaJualCtrl.text) ?? 0,
      icon: Icons.medication_rounded,
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
      appBar: _appBar('Tambah Obat'),

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
                  Navigator.pop(context, _obatBaru);
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
                            'DATA OBAT\nBERHASIL\nDITAMBAHKAN',
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

  PreferredSizeWidget _appBar(String title) => AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          title,
          style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark),
        ),
        shape: const Border(bottom: BorderSide(color: AppColors.border)),
      );

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
              _selectedDate != null ? _fmt(_selectedDate!) : 'Pilih Tanggal',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: _selectedDate != null ? AppColors.textDark : AppColors.lightGrey,
              ),
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
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white),
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