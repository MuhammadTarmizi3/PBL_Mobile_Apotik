// Aturan Wajib Flutter: Library UI dasar
import 'package:flutter/material.dart';

// Mengambil palet warna khusus buatan kita
import '../../utils/app_colors.dart';
// Import halaman antrian untuk tombol "Lihat Semua"
import 'lihat_semua_antrian_page.dart';
// Import halaman detail antrian untuk tombol panah kanan
import 'detail_antrian_page.dart';

// ── Model/Struktur Data Antrian ─────────────────────────────────────────────
// Ini adalah "cetakan" (class) untuk menyimpan data antrian
class Antrian {
  final String nomor; // Nomor antrian, misal: A04
  final String nama; // Nama pasien
  final String idResep; // ID struk resep
  String status; // Status antrian: 'menunggu', 'dipanggil', 'skip', 'selesai'

  // Constructor: Wajib (required) diisi semua datanya saat dipanggil
  Antrian({
    required this.nomor,
    required this.nama,
    required this.idResep,
    required this.status,
  });
}

/// Halaman Dashboard Petugas dengan layout presisi sesuai desain Figma.
// StatefulWidget: Karena data di halaman ini (jumlah antrian, status dipanggil, dll)
// akan BERUBAH SECARA LANGSUNG saat tombol ditekan.
class DashboardPetugasPage extends StatefulWidget {
  const DashboardPetugasPage({super.key});

  @override
  State<DashboardPetugasPage> createState() => _DashboardPetugasPageState();
}

class _DashboardPetugasPageState extends State<DashboardPetugasPage> {
  // ── Variabel Data Dummy (Data Sementara) ───────────────────────────────────
  // Anggap saja ini data yang diambil dari database (tapi kita ketik manual dulu)
  List<Antrian> daftarAntrian = [
    Antrian(nomor: 'A04', nama: 'Budi Santoso', idResep: '001', status: 'dipanggil'),
    Antrian(nomor: 'A05', nama: 'Siti Aminah', idResep: '002', status: 'menunggu'),
    Antrian(nomor: 'A06', nama: 'Ahmad Rizki', idResep: '003', status: 'menunggu'),
    Antrian(nomor: 'A07', nama: 'Dewi Lestari', idResep: '004', status: 'menunggu'),
    Antrian(nomor: 'A08', nama: 'Eko Prasetyo', idResep: '005', status: 'menunggu'),
    Antrian(nomor: 'A01', nama: 'Rina Wijaya', idResep: '006', status: 'selesai'),
    Antrian(nomor: 'A02', nama: 'Joko Susilo', idResep: '007', status: 'selesai'),
  ];

  // ── Logic Data (Getter/Penyaring Data) ─────────────────────────────────────
  // Mencari pasien yang statusnya 'dipanggil'. Kalau gak ketemu, ambil yang urutan pertama (first)
  Antrian get sedangDipanggil => daftarAntrian.firstWhere(
        (a) => a.status == 'dipanggil',
        orElse: () => daftarAntrian.first,
      );

  // Menyaring khusus daftar pasien yang masih 'menunggu'
  List<Antrian> get antrianMenunggu =>
      daftarAntrian.where((a) => a.status == 'menunggu').toList();

  // Menyaring khusus daftar pasien yang di-'skip' (dilewati)
  List<Antrian> get antrianSkip =>
      daftarAntrian.where((a) => a.status == 'skip').toList();

  // Menyaring khusus daftar pasien yang sudah 'selesai'
  List<Antrian> get antrianSelesai =>
      daftarAntrian.where((a) => a.status == 'selesai').toList();

  // Menghitung total antrian aktif (menunggu + skip + 1 yg sedang dipanggil)
  int get totalAntrian => antrianMenunggu.length + antrianSkip.length + 1;

  // ── Fungsi Tombol (Action) ─────────────────────────────────────────────────
  
  // Fungsi dipanggil saat klik tombol "Panggil Ulang"
  void _panggilUlang() {
    final current = sedangDipanggil;
    // ScaffoldMessenger: Memunculkan notifikasi pop-up kecil di bawah (SnackBar)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Memanggil ${current.nama} (${current.nomor})'),
        backgroundColor: AppColors.teal,
        behavior: SnackBarBehavior.floating, // Muncul mengambang
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 2), // Lama muncul 2 detik
      ),
    );
  }

  // Fungsi dipanggil saat klik tombol "Skip"
  void _skipAntrian() {
    // setState: Wajib dipanggil untuk kasih tau Flutter kalau ada data yg berubah
    // supaya halamannya digambar ulang
    setState(() {
      final current = sedangDipanggil;
      current.status = 'skip'; // Ubah status pasien ini jadi skip
      
      // Jika ada yang antre, panggil orang berikutnya (ubah statusnya jadi dipanggil)
      if (antrianMenunggu.isNotEmpty) {
        antrianMenunggu.first.status = 'dipanggil';
      } else if (antrianSkip.isNotEmpty) {
        antrianSkip.first.status = 'dipanggil';
      }
    });

    // Munculkan notifikasi
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Antrian di-skip dan dipindahkan ke urutan bawah'),
        backgroundColor: AppColors.danger, // Merah
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Fungsi dipanggil saat klik tombol "Selesai & Lanjut"
  void _selesaiDanLanjut() {
    setState(() {
      final current = sedangDipanggil;
      current.status = 'selesai'; // Ubah status jadi selesai
      
      // Lanjut panggil urutan setelahnya
      if (antrianMenunggu.isNotEmpty) {
        antrianMenunggu.first.status = 'dipanggil';
      } else if (antrianSkip.isNotEmpty) {
        antrianSkip.first.status = 'dipanggil';
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Pasien selesai dilayani'),
        backgroundColor: AppColors.teal, // Hijau Tosca
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Fungsi pindah ke halaman Semua Antrian
  void _lihatSemua() {
    Navigator.push(
      context,
      MaterialPageRoute(
        // Pindah sambil membawa data `daftarAntrian`
        builder: (context) => LihatSemuaAntrianPage(daftarAntrian: daftarAntrian),
      ),
    );
  }

  // Konstanta Warna khusus halaman ini untuk mempermudah coding
  static const Color _darkTeal = AppColors.primary;
  static const Color _dangerRed = AppColors.danger;

  // ── Build Tampilan Utama ───────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    // SafeArea agar tidak nabrak poni HP
    return SafeArea(
      // SingleChildScrollView: Supaya layar bisa discroll kalau kepanjangan
      child: SingleChildScrollView(
        // Padding: Memberi jarak tepi kiri-kanan (horizontal 20)
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        
        // Column: Menyusun kartu/widget secara vertikal
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Rata kiri
          children: [
            _buildTodayQueueCard(), // 1. Kartu biru besar (Antrian Hari Ini)
            
            const SizedBox(height: 16), // Jarak antar kotak
            
            // IntrinsicHeight: Aturan ajaib Flutter untuk membuat elemen di dalam Row (sebelahan)
            // memiliki tinggi yang SAMA RATA secara otomatis!
            IntrinsicHeight(
              child: Row(
                children: [
                  // Expanded agar kotak kiri ambil setengah ruang layar
                  Expanded(
                    child: _buildSmallStatusCard(
                      'BELUM DI PANGGIL',
                      '${antrianMenunggu.length}',
                      AppColors.warning,
                      Icons.hourglass_bottom_rounded,
                    ),
                  ),
                  const SizedBox(width: 12), // Jarak tengah antar kotak
                  // Expanded agar kotak kanan ambil setengah ruang sisanya
                  Expanded(
                    child: _buildSmallStatusCard(
                      'SELESAI',
                      '${antrianSelesai.length}',
                      AppColors.teal,
                      Icons.check_circle_outline_rounded,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            _buildCallingCard(), // 3. Kartu Putih Besar (Sedang Dipanggil)
            
            const SizedBox(height: 16),
            
            _buildNextQueueSection(), // 4. Kartu Bawah (Antrean Berikutnya)
          ],
        ),
      ),
    );
  }

  // ── FUNGSI: Menggambar Kartu Biru Besar (Antrian Hari Ini) ─────────────────
  Widget _buildTodayQueueCard() {
    return Container(
      width: double.infinity, // Ambil lebar penuh layar
      padding: const EdgeInsets.all(24), // Ruang lega di dalam kotak
      decoration: BoxDecoration(
        color: _darkTeal, // Background biru tua
        borderRadius: BorderRadius.circular(16), // Melengkungkan sudut
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Tinggi kotaknya menyesuaikan isinya saja
        children: [
          const Text(
            'ANTRIAN HARI INI',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.lightCyan,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 4),
          // RichText: Digunakan untuk menggabungkan tulisan dengan "Style/Ukuran yang berbeda" dalam satu baris
          RichText(
            text: TextSpan(
              children: [
                // Teks Angkanya besar tebal
                TextSpan(
                  text: '$totalAntrian',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 40,
                    fontWeight: FontWeight.w700,
                    color: AppColors.surface,
                  ),
                ),
                // Teks " Pasien" kecil biasa
                const TextSpan(
                  text: '\u2003\u2003Pasien', 
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    color: AppColors.lightCyan,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── FUNGSI: Menggambar Kartu Kecil (Belum Dipanggil & Selesai) ─────────────
  Widget _buildSmallStatusCard(
    String title, // Label atas (BELUM DIPANGGIL)
    String count, // Angka (10, 5, dll)
    Color color,  // Warna icon
    IconData icon, // Gambar iconnya
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface, // Putih
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 1), // Garis tepi
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            offset: const Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16, // Ukuran teks dibesarkan
                    fontWeight: FontWeight.w600,
                    color: AppColors.slateGrey,
                  ),
                  overflow: TextOverflow.ellipsis, // Kalau teks kepanjangan otomatis dipotong dikasih titik-titik "..."
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            count, // Menampilkan Angkanya
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 26, // Sangat besar
              fontWeight: FontWeight.w400,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }

  // ── FUNGSI: Menggambar Kartu Putih Utama (Sedang Dipanggil) ────────────────
  Widget _buildCallingCard() {
    final current = sedangDipanggil; // Panggil variabel getter di atas
    
    return Container(
      padding: const EdgeInsets.all(24), 
      decoration: BoxDecoration(
        color: AppColors.surface, // Background putih
        borderRadius: BorderRadius.circular(16), 
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 10), // Bayangan agak ditarik ke bawah 10px
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header Status (Teks hijau & Bulatan Hijau Kecil)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Kiri dan Kanan jauh-jauhan
            children: [
              const Text(
                'SEDANG DIPANGGIL',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: AppColors.teal,
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                  letterSpacing: 0.5,
                ),
              ),
              // Bulatan hijau dekorasi
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: AppColors.mintDark,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // ── Teks Angka Nomor Antrian Terbesar
          Text(
            current.nomor,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16, 
              fontWeight: FontWeight.w500,
              color: AppColors.textDark,
              height: 1.1,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // ── Kotak Informasi Pasien (Ada Garis Hijau di Kirinya)
          Container(
            padding: const EdgeInsets.only(left: 14), // Dikasih jarak kiri dari garis
            decoration: const BoxDecoration(
              // Inilah cara bikin garis hijau ketebalan 4px khusus di sebelah KIRI aja
              border: Border(left: BorderSide(color: AppColors.teal, width: 4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nama Pasien
                Text(
                  current.nama,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                // ID Resep + Icon
                Row(
                  children: [
                    const Icon(
                      Icons.receipt_long_outlined,
                      size: 16,
                      color: AppColors.textMuted,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'ID Resep: ${current.idResep}',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),

          // ── Tombol Kiri Kanan: PANGGIL ULANG & SKIP
          Row(
            children: [
              // 1. Tombol Panggil Ulang (Setengah kiri)
              Expanded(
                child: SizedBox(
                  height: 74, 
                  // OutlinedButton: Tombol yang isinya transparan/putih tapi punya garis tepi (border)
                  child: OutlinedButton(
                    onPressed: _panggilUlang, // Panggil fungsi notifikasi
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.teal, width: 1.5), // Garis tepi hijau tosca
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: EdgeInsets.zero, // Hapus jarak dalam bawaan biar teksnya aman
                    ),
                    // Menggunakan Row karena Icon di KIRI dan Teks di KANAN
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center, // Membuat seluruh konten berkumpul di tengah tombol
                      crossAxisAlignment: CrossAxisAlignment.center, // Membuat Icon dan pusat komponen teks sejajar lurus
                      children: [
                        // 1. Icon Refresh (Kiri)
                        const Icon(
                          Icons.refresh_rounded,
                          color: AppColors.teal,
                          size: 26, // Ukuran ikon yang pas
                        ),
                        
                        // Jarak horizontal antara Icon dan Teks
                        const SizedBox(width: 12),
                        
                        // 2. Column Teks (Kanan)
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center, // Menjaga susunan teks tetap di tengah secara vertikal
                          crossAxisAlignment: CrossAxisAlignment.start, // Membuat teks "Panggil" dan "Ulang" rata kiri
                          children: const [
                            Text(
                              'Panggil',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppColors.teal,
                                height: 1.1, // Merapatkan ruang kosong di atas/bawah huruf
                              ),
                            ),
                            
                            // Jarak vertikal super tipis antar kata
                            SizedBox(height: 2), 
                            
                            Text(
                              '  Ulang',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppColors.teal,
                                height: 1.1,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              const SizedBox(width: 16), // Jarak di antara kedua tombol
              
              // 2. Tombol Skip (Setengah kanan)
              Expanded(
                child: SizedBox(
                  height: 74,
                  // ElevatedButton: Tombol solid (berwarna pekat)
                  child: ElevatedButton(
                    onPressed: _skipAntrian, // Panggil fungsi skip
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _dangerRed, // Warna Merah (bahaya)
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16), 
          
          // ── Tombol Full Bawah: SELESAI & LANJUT
          SizedBox(
            width: double.infinity, // Membentang penuhi lebar layar
            height: 60,
            child: ElevatedButton(
              onPressed: _selesaiDanLanjut, // Panggil fungsi selesai
              style: ElevatedButton.styleFrom(
                backgroundColor: _darkTeal, // Biru Tua
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center, // Tengahin teks dan icon
                children: const [
                  Icon(Icons.done_all_rounded, color: Colors.white, size: 22),
                  SizedBox(width: 10),
                  Text(
                    'Selesai & Lanjut',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── FUNGSI: Menggambar Kartu Antrean Berikutnya ────────────────────────────
  Widget _buildNextQueueSection() {
    // Gabungkan seluruh antrian yang 'menunggu' dan 'skip' jadi satu list
    final upcomingAntrian = [...antrianMenunggu, ...antrianSkip];

    // Kalau nggak ada antrean sama sekali, jangan tampilkan apa-apa
    if (upcomingAntrian.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header: Teks Judul dan Tombol "Lihat Semua"
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Antrean Berikutnya',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: AppColors.textDark,
              ),
            ),
            TextButton(
              onPressed: _lihatSemua,
              child: const Text(
                'Lihat Semua',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: AppColors.teal,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 12),
        
        // Render semua sisa antrean menggunakan ListView
        ListView.separated(
          shrinkWrap: true, // Wajib! Agar tinggi ListView ngikutin konten
          physics: const NeverScrollableScrollPhysics(), // Mematikan scroll internal agar nyatu dengan SingleChildScrollView
          itemCount: upcomingAntrian.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12), // Jarak antar kotak antrian
          itemBuilder: (context, index) {
            final antrian = upcomingAntrian[index];
            return _buildQueueCard(antrian); // Panggil fungsi pembuat UI per-kotak
          },
        ),
      ],
    );
  }

  // ── FUNGSI: Menggambar UI Per-kotak List Antrian ───────────────────────────
  Widget _buildQueueCard(Antrian antrian) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface, // Background putih
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // Lingkaran untuk Nomor Antrean (A05, A06, dll)
          CircleAvatar(
            backgroundColor: AppColors.mint, 
            radius: 24,
            child: Text(
              antrian.nomor,
              style: const TextStyle(
                color: AppColors.teal,
                fontWeight: FontWeight.w400,
                fontFamily: 'Poppins',
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Teks Informasi (Nama, Resep, Status)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  antrian.nama,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: AppColors.textDark,
                  ),
                ),
                Text(
                  'R-${antrian.idResep} • ${antrian.status == 'menunggu' ? 'Menunggu' : 'Skip'}',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          
          // Tombol Panah (Detail)
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(32),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailAntrianPage(antrian: antrian),
                  ),
                );
              },
              child: Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: AppColors.lightestGrey,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textMuted,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
