// Aturan Wajib Flutter: Import library UI dasar
import 'package:flutter/material.dart';
// Import file daftar warna buatan sendiri
import '../../utils/app_colors.dart';

// StatefulWidget: Halaman detail resep yang butuh mengubah tampilannya 
// (seperti tambah/kurang kuantitas obat, memunculkan tombol sukses, dll)
class DetailEResepPage extends StatefulWidget {
  /// Variabel ini WAJIB ada, gunanya untuk menampung data resep yang dikirim 
  /// (diteruskan) dari halaman sebelumnya (EResepPage) saat tombol "Pilih" ditekan.
  final Map<String, dynamic> resep;

  const DetailEResepPage({super.key, required this.resep});

  @override
  State<DetailEResepPage> createState() => _DetailEResepPageState();
}

class _DetailEResepPageState extends State<DetailEResepPage> {
  // Menyimpan warna dalam konstanta (variabel tetap) agar gampang dipanggil
  static const Color _darkTeal = AppColors.primary;

  // Variabel penanda status layar: apakah prosesnya berhasil atau resep tidak sesuai?
  bool _berhasil = false;
  bool _tidakSesuai = false;

  // Guard agar pop-up tidak langsung tertutup oleh tap yang sama saat klik tombol Simpan.
  bool _siapTutupPopup = false;

  // Data dummy (contoh buatan) daftar obat di apotek. 
  // Map menyimpan data secara terstruktur dengan sistem kunci: nilai (key: value)
  final List<Map<String, dynamic>> _daftarObat = [
    {
      'id': '#0001',
      'nama': 'Cefadroxil 500mg',
      'kategori': 'Antibiotik',
      'exp': '2027-05-01', // Tanggal kedaluwarsa
      'stok': 80, // Stok di gudang
      'qty': 0, // Kuantitas (Jumlah yang mau diambil)
    },
    {
      'id': '#0002',
      'nama': 'Mylanta Cair 50ml',
      'kategori': 'Antasida',
      'exp': '2026-07-07',
      'stok': 45,
      'qty': 0,
    },
    {
      'id': '#0003',
      'nama': 'Bodrex Migra',
      'kategori': 'Analgesik',
      'exp': '2026-12-15',
      'stok': 65,
      'qty': 0,
    },
    {
      'id': '#0004',
      'nama': 'Paracetamol 500mg',
      'kategori': 'Analgesik',
      'exp': '2027-01-20',
      'stok': 120,
      'qty': 0,
    },
    {
      'id': '#0005',
      'nama': 'Sangobion',
      'kategori': 'Suplemen',
      'exp': '2027-03-10',
      'stok': 60,
      'qty': 0,
    },
    {
      'id': '#0006',
      'nama': 'Enervon-C',
      'kategori': 'Suplemen',
      'exp': '2026-11-30',
      'stok': 90,
      'qty': 0,
    },
    {
      'id': '#0007',
      'nama': 'Diapet',
      'kategori': 'Antidiare',
      'exp': '2026-09-15',
      'stok': 75,
      'qty': 0,
    },
  ];

  // ── Helpers (Fungsi-Fungsi Logika) ──────────────────────────────────────────

  // Fungsi untuk MENAMBAH kuantitas obat yang diklik (tombol +)
  void _increment(int index) {
    // Mengambil nilai stok dan kuantitas saat ini
    final int stok = _daftarObat[index]['stok'] as int;
    final int qty = _daftarObat[index]['qty'] as int;
    
    // Logika IF: Jika kuantitas masih KURANG DARI stok, maka boleh ditambah.
    // Tujuannya agar kita gak ngambil obat melebihi stok yang ada di gudang.
    if (qty < stok) {
      // setState wajib ada biar teks angka di layarnya ikut ke-refresh bertambah
      setState(() => _daftarObat[index]['qty'] = qty + 1);
    }
  }

  // Fungsi untuk MENGURANGI kuantitas obat yang diklik (tombol -)
  void _decrement(int index) {
    final int qty = _daftarObat[index]['qty'] as int;
    // Logika IF: Jangan sampai jumlahnya minus/di bawah nol
    if (qty > 0) {
      setState(() => _daftarObat[index]['qty'] = qty - 1);
    }
  }

  /// Fungsi Canggih: Validasi kesesuaian Resep dengan Obat yang Diambil
  /// Mengecek apakah semua obat yang tertulis di kertas resep, benar-benar sudah 
  /// diambil minimal 1 buah (qty > 0) dari daftar rak obat.
  bool _isSesuai() {
    // Ambil daftar nama obat dari halaman sebelumnya
    // 'widget.resep' digunakan karena kita mengambil dari variabel class utamanya
    final List<String> items = List<String>.from(widget.resep['items'] as List);
    
    // Looping/Perulangan: Mengecek setiap obat satu per satu
    for (final item in items) {
      // Membersihkan teks dari hal gak penting. Contoh: "1x Mylanta Cair" jadi "mylanta cair"
      final String keyword = item
          .replaceFirst(RegExp(r'^\d+x\s*'), '') // Membuang tulisan "1x ", "2x ", dll
          .toLowerCase() // Ubah jadi huruf kecil semua
          .trim(); // Buang spasi di ujung kiri/kanan
          
      // Mencari apakah obat dengan keyword ini ADA di dalam rak _daftarObat dan JUMLAHNYA (qty) > 0?
      final bool ada = _daftarObat.any(
        (o) =>
            (o['nama'] as String).toLowerCase().contains(keyword) &&
            (o['qty'] as int) > 0,
      );
      
      // Jika ternyata ada 1 aja obat resep yang nggak ditemuin di keranjang (qty 0), langsung nyatakan GAGAL (false)
      if (!ada) return false;
    }
    // Jika lolos semua pengecekan, berarti SESUAI (true)
    return true;
  }

  // Fungsi untuk tombol Simpan diklik
  void _onSimpan() {
    // Jika validasinya sesuai
    if (_isSesuai()) {
      setState(() {
        _berhasil = true; // Munculkan pop-up berhasil
        _tidakSesuai = false; // Hapus tulisan error
        _siapTutupPopup = false; // Wajib tap terpisah untuk menutup
      });

      // Aktifkan penutupan pop-up setelah frame tap Simpan selesai,
      // supaya tidak langsung ter-pop oleh event tap yang sama.
      Future.delayed(const Duration(milliseconds: 180), () {
        if (!mounted || !_berhasil) return;
        setState(() => _siapTutupPopup = true);
      });
    } else {
      // Jika ternyata ada yang belum diambil
      setState(() {
        _tidakSesuai = true; // Munculkan tulisan error "RESEP TIDAK SESUAI"
        _berhasil = false;
        _siapTutupPopup = false;
      });
    }
  }

  // ── Build (Tempat menggambar layar) ────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: _buildAppBar(),
      
      // Stack: Ini adalah widget super keren untuk menumpuk widget seperti "kue lapis".
      // Berguna untuk memunculkan layar Pop-up Sukses di ATAS konten utama.
      body: Stack(
        children: [
          // ── LAPISAN BAWAH: Konten Utama Layar
          Column(
            children: [
              // Expanded agar daftar obat ini memenuhi sisa ruang layar di atas tombol bawah
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionLabel('RESEP TERPILIH'), // Label teks
                      const SizedBox(height: 8),
                      
                      _buildResepTerpilihCard(), // Kotak detail resep dari halaman sebelumnya
                      
                      const SizedBox(height: 20),
                      
                      _sectionLabel('DAFTAR OBAT (LIST OBAT)'),
                      
                      // Logika If Flutter: JIKA _tidakSesuai bernilai true (terjadi error)
                      // maka tampilkan teks peringatan warna merah.
                      if (_tidakSesuai) ...[
                        const SizedBox(height: 6),
                        // 💡 KUNCI UTAMA: Bungkus Text dengan widget Center
                        const Center(
                          child: Text(
                            'RESEP TIDAK SESUAI',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.pureRed, // Teks merah!
                              letterSpacing: 0.4,
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 8),
                      
                      // Looping untuk menggambar seluruh obat di rak secara otomatis
                      // asMap().entries.map digunakan agar kita bisa dapetin "index" ke-berapa (biar fungsi nambah/kurang tau yg mana yg diklik)
                      ..._daftarObat.asMap().entries.map(
                        (e) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          // Panggil fungsi gambar kartu untuk setiap obat
                          child: _buildObatCard(e.key, e.value),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Ini tombol Simpan & Batal di paling bawah layar
              _buildBottomActions(),
            ],
          ),

          // ── LAPISAN ATAS: Overlay sukses (Pop-up bayangan hitam)
          // Hanya digambar KALAU nilai _berhasil adalah true (Tombol simpan sukses diklik)
          if (_berhasil)
            // Positioned.fill: Memaksa pop-up ini menutupi seluruh layar penuh
            Positioned.fill(
              // GestureDetector: Widget untuk mendeteksi sentuhan jari (tap)
              child: GestureDetector(
                // onTap: Kalo layarnya diklik sembarangan, kita langsung TUTUP halamannya (Navigator.pop)
                onTap: () {
                  // Kalau popup baru muncul, abaikan dulu tap pertama dari tombol Simpan.
                  if (!_siapTutupPopup) return;
                  Navigator.pop(context);
                },
                child: Container(
                  color: Colors.black.withValues(alpha: 0.45), // Latar hitam transparan seperti kaca film mobil
                  child: Center(
                    child: Container(
                      // Kotak pop-up di tengah
                      margin: const EdgeInsets.symmetric(horizontal: 32),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
                      decoration: BoxDecoration(
                        color: AppColors.border, // Latar abu-abu
                        borderRadius: BorderRadius.circular(20), // Ujung sangat bulat
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min, // Biar tinggi kotaknya ngikutin isi aja
                        children: [
                          // Lingkaran Hijau Centang
                          Container(
                            width: 80,
                            height: 80,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check_rounded, // Icon centang (cek)
                              color: Colors.white,
                              size: 48,
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'RESEP BERHASIL\nDI PROSES',
                            textAlign: TextAlign.center, // Rata tengah teks
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 22,
                              fontWeight: FontWeight.w800, // Super tebal
                              color: AppColors.textDark,
                              height: 1.4, // Spasi antar baris
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

  // ── Fungsi-Fungsi Pembuat Widget ─────────────────────────────────────────────

  // Menggambar Header Atas Layar (AppBar)
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      // Tombol Panah Kembali (Back)
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
        // Aksi tutup halaman ini
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'E-Resep',
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
    );
  }

  // Fungsi pembantu pembuat teks Label kecil abu-abu
  Widget _sectionLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: AppColors.textMuted,
        letterSpacing: 0.8, // Spasi antar huruf renggang dikit biar keren
      ),
    );
  }

  // Menggambar Kotak Resep yang dipilih dari layar sebelumnya
  Widget _buildResepTerpilihCard() {
    // Karena ngambilnya dari StatefulWidget induk, panggil "widget." dulu
    final String nomor = widget.resep['nomor'] as String;
    final List<String> items = List<String>.from(widget.resep['items'] as List);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.tealDark, width: 2), 
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Kotak nomor urut warna biru pekat (Navy)
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.tealDark,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              nomor,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: AppColors.surface,
              ),
            ),
          ),
          const SizedBox(width: 14),
          // Kolom Daftar Obat Resep
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Resep',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: AppColors.tealDark, // Teks Navy
                  ),
                ),
                const SizedBox(height: 4),
                // Ulangi buat nyetak teks obat
                ...items.map(
                  (item) => Text(
                    item,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      color: AppColors.tealDark, // Warna hijau obat
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Menggambar Kotak Rak Obat 1 buah (beserta tombol + dan -)
  Widget _buildObatCard(int index, Map<String, dynamic> obat) {
    // Ambil data qty dan stok dari Map
    final int qty = obat['qty'] as int;
    final int stok = obat['stok'] as int;
    final bool isZero = qty == 0; // Apakah jumlah yang mau diambil 0?

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface, // Kotak putih
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ID obat dan Stok Sisa (Kiri Kanan)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Badge kecil warna hijau tosca pucat (0.12) buat nampilin ID Obat
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.mint,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  obat['id'] as String,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.tealMedium,
                  ),
                ),
              ),
              // Teks Stok di pojok kanan, dibungkus Padding agar tidak mepet ujung
              Padding(
                padding: const EdgeInsets.only(right: 60.0),
                child: Text(
                  'Stok: $stok',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Nama Obat
          Text(
            obat['nama'] as String,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          // Kategori (Analgesik dll)
          Text(
            obat['kategori'] as String,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 8),
          // Baris Expired (Kedaluwarsa)
          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined, // Icon kalender
                size: 12,
                color: AppColors.textMuted,
              ),
              const SizedBox(width: 5),
              Text(
                'Exp: ${obat['exp']}',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Row untuk Control Tambah/Kurang Jumlah Obat
          Row(
            children: [
              // ── Tombol Kurang (Minus)
              GestureDetector(
                onTap: () => _decrement(index), // Jalankan fungsi ngurangin
                child: Icon(
                  Icons.remove_circle_outline_rounded,
                  size: 28, // Ukuran lumayan besar biar enak dipencet
                  // Logika Warna: Kalau qty 0, warnanya merah pudar seolah mati (disable). Kalau > 0, merah terang!
                  color: isZero ? AppColors.danger.withValues(alpha: 0.4) : AppColors.red,
                ),
              ),
              const SizedBox(width: 16),
              
              // ── Angka Qty di tengah
              Text(
                '$qty',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(width: 16),
              
              // ── Tombol Tambah (Plus)
              GestureDetector(
                onTap: () => _increment(index), // Jalankan fungsi nambah
                child: Icon(
                  Icons.add_circle_outline_rounded,
                  size: 28,
                  // Logika Warna: Kalau udah mentok max stok gudang, warnanya abu-abu (neutral). Kalau belom mentok, hijau tosca terang!
                  color: qty < stok ? AppColors.teal : AppColors.neutral,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Menggambar Kotak Tombol Simpan & Batal di paling bawah aplikasi
  Widget _buildBottomActions() {
    return Container(
      color: AppColors.surface, // Background putih biar gabung sama layar
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Sesuaikan ukuran anak aja
        children: [
          // ── TOMBOL SIMPAN
          SizedBox(
            width: double.infinity, // Mentok kiri kanan
            height: 50, // Tinggi nyaman dipencet
            child: ElevatedButton.icon( // Ada icon + teks
              onPressed: _onSimpan, // Jalankan fungsi validasi
              icon: const Icon(
                Icons.save_rounded, // Icon disket (save)
                color: Colors.white,
                size: 20,
              ),
              label: const Text(
                'Simpan',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _darkTeal, // Biru navy
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Melengkung
                ),
              ),
            ),
          ),
          const SizedBox(height: 10), // Spasi antar tombol
          
          // ── TOMBOL BATAL
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton( // Ini tombol polos tanpa icon
              onPressed: () => Navigator.pop(context), // Balik ke halaman sblmnya (buang perubahan)
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.red, // Warnanya merah tanda bahaya (cancel)
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Batal',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
