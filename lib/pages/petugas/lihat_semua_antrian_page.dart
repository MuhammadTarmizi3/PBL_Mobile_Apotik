// Aturan Wajib Flutter: Library UI bawaan flutter
import 'package:flutter/material.dart';

// Mengambil palet warna custom kita
import '../../utils/app_colors.dart';
// Mengambil class/model 'Antrian' dari file dashboard (supaya tau struktur datanya)
import 'dashboard_petugas_page.dart';

// StatelessWidget: Karena kita hanya me-render daftar (list) antrian yang dikirim dari halaman sebelah.
// Jika datanya butuh berubah terus menerus SECARA LANGSUNG dari sini, maka harusnya StatefulWidget.
class LihatSemuaAntrianPage extends StatelessWidget {
  // Variabel untuk menampung data antrian yang dikirim dari halaman dashboard
  // List<Antrian> berarti ini adalah daftar/kumpulan objek "Antrian"
  final List<Antrian> daftarAntrian;

  // Constructor: Saat halaman ini dibuka, dia WAJIB (required) menerima kiriman data 'daftarAntrian'
  const LihatSemuaAntrianPage({super.key, required this.daftarAntrian});

  @override
  Widget build(BuildContext context) {
    // ── LOGIKA PENGURUTAN (SORTING) DATA
    // Urutkan: Menunggu → Skip → Selesai
    // Kita memfilter (where) data antrian sesuai statusnya lalu menjadikannya list (toList)
    final menunggu = daftarAntrian.where((a) => a.status == 'menunggu').toList();
    final skip = daftarAntrian.where((a) => a.status == 'skip').toList();
    final selesai = daftarAntrian.where((a) => a.status == 'selesai').toList();
    
    // Tanda ... (Spread Operator) digunakan untuk menggabungkan ketiga list di atas menjadi SATU list baru
    // yang sudah berurutan (Menunggu dulu, baru Skip, baru Selesai)
    final semuaAntrian = [...menunggu, ...skip, ...selesai];

    // Scaffold: Pondasi/kanvas halaman
    return Scaffold(
      backgroundColor: AppColors.backgroundAlt, // Background abu-abu muda
      
      // ── Header Layar (AppBar)
      appBar: AppBar(
        backgroundColor: AppColors.surface, // Background putih
        elevation: 0, // Tanpa bayangan
        scrolledUnderElevation: 0,
        centerTitle: true, // Judul otomatis di tengah
        
        // leading: Mengatur Widget apa yang ada di paling kiri AppBar
        // Di sini kita kasih tombol panah "Back" manual
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark), // Icon panah kiri
          // onPressed: Saat tombol diklik, jalankan fungsi Navigator.pop (artinya: Mundur ke halaman sebelumnya / Tutup halaman ini)
          onPressed: () => Navigator.pop(context),
        ),
        
        // title: Judul AppBar
        title: const Text(
          'Semua Antrian',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        // Garis batas bawah AppBar
        shape: const Border(
          bottom: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      
      // ── Isi Utama Halaman (Body)
      // Aturan Logika If: Jika 'semuaAntrian' kosong (isEmpty), tampilkan Icon Kosong.
      // Jika tidak kosong (:), tampilkan ListView.builder.
      body: semuaAntrian.isEmpty
          ? Center(
              // Jika kosong, tampilkan ini di tengah layar (Center)
              child: Column(
                mainAxisSize: MainAxisSize.min, // Biar tinggi Column sesuai isi saja, bukan penuh layar
                children: [
                  Icon(
                    Icons.inbox_outlined, // Icon Kotak Kosong
                    size: 64,
                    color: AppColors.borderLight, // Warna abu-abu pucat
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Tidak ada antrian',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: AppColors.textMuted,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              // Jika ada datanya, pakai ListView.builder untuk mencetak widget sebanyak jumlah data secara efisien
              padding: const EdgeInsets.all(16), // Jarak tepi sekeliling
              itemCount: semuaAntrian.length, // Berapa banyak data yang mau dicetak
              itemBuilder: (context, index) {
                // Ambil 1 data antrian berdasarkan urutan (index)
                final antrian = semuaAntrian[index];
                // Panggil fungsi untuk menggambar desain kartunya berdasarkan data antrian tsb
                return _buildAntrianCard(antrian);
              },
            ),
    );
  }

  // ── FUNGSI UNTUK MENGGAMBAR 1 KARTU ANTRIAN ─────────────────────────────
  Widget _buildAntrianCard(Antrian antrian) {
    // Siapkan variabel kosong untuk menyimpan warna, teks, dan icon
    Color statusColor;
    String statusText;
    IconData statusIcon;

    // Switch case (mirip If-Else): Mengecek apa nilai dari antrian.status
    switch (antrian.status) {
      case 'menunggu': // Jika "menunggu"
        statusColor = AppColors.warning; // Warnanya orange/kuning
        statusText = 'Menunggu';
        statusIcon = Icons.hourglass_bottom_rounded; // Icon jam pasir
        break;
      case 'dipanggil': // Jika "dipanggil"
        statusColor = AppColors.teal; // Warna hijau tosca
        statusText = 'Sedang Dipanggil';
        statusIcon = Icons.notifications_active_rounded; // Icon lonceng
        break;
      case 'skip': // Jika di-skip
        statusColor = AppColors.danger; // Warna merah
        statusText = 'Di-skip';
        statusIcon = Icons.skip_next_rounded; // Icon lewati
        break;
      case 'selesai': // Jika selesai
        statusColor = AppColors.teal; // Warna hijau tosca
        statusText = 'Selesai';
        statusIcon = Icons.check_circle_rounded; // Icon centang
        break;
      default: // Jika tidak ada yang cocok sama sekali (jaga-jaga error)
        statusColor = AppColors.textMuted;
        statusText = 'Unknown';
        statusIcon = Icons.help_outline_rounded;
    }

    // Mengembalikan Widget Kartu
    return Container(
      margin: const EdgeInsets.only(bottom: 12), // Jarak ke bawah antar kartu (12px)
      padding: const EdgeInsets.all(16), // Ruang lega di dalam kartu
      decoration: BoxDecoration(
        color: AppColors.surface, // Background putih
        borderRadius: BorderRadius.circular(12), // Ujung melengkung
        
        // border: Jika statusnya dipanggil, garis tepinya tebal dan berwarna teal (hijau tosca) biar mencolok!
        // Kalau tidak, cukup warna abu-abu pudar biasa.
        border: Border.all(
          color: antrian.status == 'dipanggil' 
              ? AppColors.teal 
              : AppColors.border,
          width: antrian.status == 'dipanggil' ? 2 : 1, // Tebalnya 2px vs 1px
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04), // Efek bayangan halus
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      // Row: Menyusun widget menyamping (kiri: Kotak Nomor, kanan: Informasi teks)
      child: Row(
        children: [
          // ── Kotak Nomor Antrian
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              // Jika dipanggil, kotak jadi full teal/hijau tosca.
              // Kalau nggak, biru muda tipis (0.1)
              color: antrian.status == 'dipanggil'
                  ? AppColors.teal
                  : AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center, // Otomatis teks di tengah kotak
            child: Text(
              antrian.nomor, // Mencetak angka antrian "001" dsb
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                // Jika dipanggil, teks warna putih. Kalau tidak, warna biru primary.
                color: antrian.status == 'dipanggil'
                    ? Colors.white
                    : AppColors.primary,
              ),
            ),
          ),
          
          const SizedBox(width: 14), // Jarak antara kotak nomor dan teks nama
          
          // ── Informasi Pasien (Nama, Resep, Status)
          // Expanded: Agar info pasien mengambil sisa tempat dan tidak meledak keluar layar
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Rata kiri
              children: [
                // Teks Nama Pasien
                Text(
                  antrian.nama,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                
                const SizedBox(height: 4), // Jarak super tipis
                
                // Teks ID Resep
                Text(
                  'ID Resep: ${antrian.idResep}', // Teknik String Interpolation ($) untuk menggabung teks dengan variabel
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    color: AppColors.textMuted,
                  ),
                ),
                
                const SizedBox(height: 6), // Jarak tipis ke bagian Status
                
                // Row untuk menyusun Icon dan Teks Status (Menunggu, Dipanggil, dll)
                Row(
                  children: [
                    // Menampilkan Icon berdasarkan Switch Case di atas
                    Icon(statusIcon, size: 14, color: statusColor),
                    
                    const SizedBox(width: 4), // Spasi kecil antara icon & teks
                    
                    // Menampilkan Teks Status berdasarkan Switch Case di atas
                    Text(
                      statusText,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: statusColor, // Warna disamakan dengan warna status
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
