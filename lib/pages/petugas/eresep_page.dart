// Aturan Wajib Flutter: Import library UI dasar Flutter
import 'package:flutter/material.dart';

// Import file warna custom kita
import '../../utils/app_colors.dart';
// Import halaman detail untuk navigasi pindah halaman saat tombol diklik
import 'detail_eresep_page.dart';

/// Konten tab E-Resep — AppBar & BottomNav dikelola MainPetugasPage.
// StatelessWidget: Karena list resep di halaman ini datanya statis/sementara dibuat hardcode
class EResepPage extends StatelessWidget {
  // Aturan Wajib: super.key
  const EResepPage({super.key});

  // Data dummy (contoh buatan) untuk list resep. 
  // Map<String, dynamic> artinya kuncinya berupa teks (String), dan isinya bisa apa saja (dynamic)
  static final List<Map<String, dynamic>> _resepList = [
    {
      'nomor': '001',
      'items': ['1x Mylanta Cair 50ml', '1x Paracetamol'],
    },
    {
      'nomor': '002',
      'items': ['1x Sangobion', '1x Enervon-C'],
    },
    {
      'nomor': '003',
      'items': ['1x Sangobion', '1x Cefadroxil 500mg'],
    },
    {
      'nomor': '004',
      'items': [
        '1x Sangobion',
        '1x Cefadroxil 500mg',
        '1x Enervon-C',
        '1x Diapet',
      ],
    },
  ];

  // Aturan Wajib: Fungsi untuk menggambar tampilan halaman
  @override
  Widget build(BuildContext context) {
    // SafeArea agar isi layar tidak tertutup poni HP
    return SafeArea(
      // ListView.separated: Widget hebat dari Flutter untuk membuat daftar (list)
      // yang bisa di-scroll ke bawah dan OTOMATIS diberi jarak (separator) antar kotaknya!
      child: ListView.separated(
        // Padding/jarak tepi untuk list secara keseluruhan
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        
        // itemCount: Beri tahu Flutter ada berapa banyak data yang mau digambar
        itemCount: _resepList.length,
        
        // separatorBuilder: Fungsi untuk menggambar "pembatas" antar data
        // Di sini kita cuma kasih spasi kosong setinggi 12 pixel
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        
        // itemBuilder: Fungsi utama untuk menggambar bentuk "kotak resep" untuk masing-masing data
        itemBuilder: (context, index) =>
            _buildResepCard(context, _resepList[index]),
      ),
    );
  }

  // ── Fungsi untuk menggambar desain 1 Kotak Kartu Resep ──────────────────────
  Widget _buildResepCard(BuildContext context, Map<String, dynamic> resep) {
    // Mengambil data 'nomor' dan 'items' dari dalam Map
    final String nomor = resep['nomor'] as String;
    final List<String> items = List<String>.from(resep['items'] as List);

    // Container sebagai pembungkus utama (Kartu putih)
    return Container(
      clipBehavior: Clip.antiAlias, // Aturan wajib agar garis kiri ikut melengkung sesuai sudut kartu
      decoration: BoxDecoration(
        color: AppColors.surface, // Background kartu putih
        borderRadius: BorderRadius.circular(12), // Ujung kartu melengkung
        // Memberi bayangan tipis
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08), // Sedikit digelapkan agar lebih terlihat
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      // Container tambahan untuk membuat garis aksen di sisi kiri
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            left: BorderSide(
              color: AppColors.navy,
              width: 6,
            ),
          ),
        ),
        // Padding di dalam kartu agar teksnya tidak mentok ke dinding batas kartu
        child: Padding(
          padding: const EdgeInsets.all(16),
          // Column karena di dalam kartu disusun secara vertikal (Isi resep -> lalu Tombol di bawahnya)
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Rata kiri
          children: [
            // Row digunakan untuk membagi layar kiri (Kotak Nomor) dan kanan (Daftar Obat)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start, // Posisi sejajar di atas
              children: [
                // ── Kotak Badge nomor antrian (Warna Biru)
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.navy, // Background kotak biru
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center, // Teks otomatis di tengah kotak
                  // Teks "001" dsb
                  child: Text(
                    nomor,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.w700, // Sangat tebal (bold)
                      color: AppColors.surface,
                    ),
                  ),
                ),
                
                const SizedBox(width: 12), // Jarak antara kotak nomor dan tulisan obat
                
                // Expanded: Aturan Wajib agar teks sebelahnya tidak melebar merusak layar (overflow)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Judul "Resep"
                      const Text(
                        'Resep',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: AppColors.navy,
                        ),
                      ),
                      const SizedBox(height: 4),
                      
                      // Looping (perulangan) otomatis untuk setiap obat yang ada di list 'items'
                      // Tanda ... (Spread Operator) digunakan untuk memecah daftar Widget menjadi satuan di dalam Column
                      ...items.map(
                        (item) => Text(
                          item, // Mencetak nama obat
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            color: AppColors.tealDark,
                            height: 1.6, // Memberi spasi jarak antar baris tulisan obat
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 14), // Jarak antara daftar obat dan tombol
            
            // ── Tombol "Pilih" di bagian bawah kartu
            // SizedBox agar lebar tombol penuh memenuhi kartu
            SizedBox(
              width: double.infinity,
              height: 44, // Tinggi tombol
              child: ElevatedButton(
                // onPressed: Apa yang terjadi jika ditekan?
                onPressed: () {
                  // Navigator.push: Perintah untuk membuka/tumpuk halaman baru (Maju)
                  // Membuka DetailEResepPage dan mengirimkan data `resep` ke halaman tersebut
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailEResepPage(resep: resep),
                    ),
                  );
                },
                // style: Warna dan bentuk tombol
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.navy, // Warna biru
                  elevation: 0, // Hilangkan bayangan bawaan
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Pilih',
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
      ),
      ), // Penutup Container tambahan (garis aksen)
    );
  }
}
