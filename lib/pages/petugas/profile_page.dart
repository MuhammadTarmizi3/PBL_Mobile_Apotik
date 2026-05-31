// Aturan Wajib Flutter: Kita harus meng-import library material.dart 
// karena hampir semua komponen visual (Widget) bawaan Flutter ada di sini.
import 'package:flutter/material.dart';

// Meng-import file warna buatan kita sendiri agar warnanya seragam di seluruh aplikasi.
import '../../utils/app_colors.dart';

/// Konten tab Profile — AppBar & BottomNav dikelola MainPetugasPage.
// StatelessWidget: Ini adalah jenis halaman/tampilan yang "statis" atau 
// tidak berubah-ubah datanya secara dinamis setelah layar ditampilkan.
class ProfilePage extends StatelessWidget {
  
  // Aturan Wajib: Constructor dengan 'super.key' digunakan agar Flutter bisa
  // mengenali Widget ini secara unik di dalam sistem kerjanya (Widget Tree).
  const ProfilePage({super.key});

  // Aturan Wajib: Fungsi 'build' adalah tempat kita "menggambar" tampilan layar.
  // Semua Widget yang mau ditampilkan ke layar harus di-return di dalam sini.
  @override
  Widget build(BuildContext context) {
    // Scaffold: Ini adalah pondasi dasar sebuah halaman HP. Dia menyediakan kerangka
    // untuk AppBar (kepala), Body (badan/isi utama), dan bisa juga untuk navigasi bawah.
    return Scaffold(
      // backgroundColor: Mengatur warna latar belakang keseluruhan halaman ini
      backgroundColor: Colors.white,
      
      // appBar: Mengatur tampilan bagian atas layar (Header aplikasi)
      appBar: AppBar(
        backgroundColor: AppColors.backgroundMint, // Warna background AppBar diubah sesuai instruksi
        elevation: 0, // Menghilangkan bayangan (shadow) bawaan di bawah AppBar
        scrolledUnderElevation: 0, // Mencegah warna AppBar berubah gelap saat di-scroll
        centerTitle: true, // Memaksa teks judul posisinya persis di tengah
        automaticallyImplyLeading: false, // Menghilangkan tombol "Back" (panah kiri) bawaan
        
        // title: Teks judul yang muncul di AppBar
        title: const Text(
          'Profile',
          style: TextStyle(
            fontFamily: 'Poppins', // Menggunakan jenis huruf Poppins
            fontSize: 16, // Ukuran huruf 17 pixel
            fontWeight: FontWeight.w600, // Ketebalan huruf (semi-bold)
            color: AppColors.textDark, // Warna teks (gelap)
          ),
        ),
        
        // shape: Digunakan di sini untuk menambah garis batas (border) tipis di bawah AppBar
        shape: const Border(
          bottom: BorderSide(color: AppColors.border, width: 1), // Garis bawah tebal 1 pixel
        ),
      ),
      
      // body: Adalah area isi utama layar (di bawah AppBar)
      // SafeArea: Aturan Wajib agar tampilan aplikasi kita tidak tertabrak poni HP (notch) 
      // atau layar sistem HP di bagian paling bawah.
      body: SafeArea(
        // SingleChildScrollView: Membuat layar ini bisa di-scroll (di-geser ke bawah)
        // supaya kalau layar HP kekecilan, isinya tidak terpotong.
        child: SingleChildScrollView(
          // Column: Widget untuk menyusun elemen secara vertikal (berjejer dari atas ke bawah)
          child: Column(
            children: [
              _buildProfileHeader(), // Memanggil fungsi untuk mencetak Foto dan Nama
              
              // SizedBox: Memberikan jarak ruang kosong (spasi) setinggi 24 pixel
              const SizedBox(height: 24), 
              
              _buildInfoSection(), // Memanggil fungsi untuk mencetak kotak Informasi Pribadi
              
              const SizedBox(height: 32), // Jarak spasi kosong lagi
              
              _buildLogoutButton(context), // Memanggil fungsi untuk mencetak Tombol Keluar
              
              const SizedBox(height: 24), // Jarak spasi di ujung paling bawah layar
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================================
  // FUNGSI KHUSUS UNTUK MENAMPILKAN FOTO PROFIL, NAMA, DAN JABATAN
  // =========================================================================
  Widget _buildProfileHeader() {
    // Pakai Column karena isinya berurutan ke bawah: Foto -> Nama -> Jabatan
    return Column(
      children: [
        const SizedBox(height: 16), // Spasi atas sebelum foto profil
        
        // Container: Widget serbaguna, di sini dipakai untuk membungkus gambar
        Container(
          width: 96, // Lebar kotak gambar (96 pixel)
          height: 96, // Tinggi kotak gambar (96 pixel)
          
          // decoration: Mengatur gaya/desain dari Container ini
          decoration: BoxDecoration(
            shape: BoxShape.circle, // Aturan Wajib untuk bikin bentuknya bulat sempurna
            border: Border.all(color: AppColors.surface, width: 3), // Bikin garis tepi foto (border)
            
            // boxShadow: Menambahkan efek bayangan di belakang foto biar terlihat timbul
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1), // Bayangan hitam tipis (10%)
                blurRadius: 12, // Seberapa menyebar bayangannya
                offset: const Offset(0, 4), // Posisi bayangan ditarik agak ke bawah
              ),
            ],
            
            // image: Untuk memasang gambar foto profil
            image: const DecorationImage(
              // NetworkImage mengambil gambar langsung dari link internet
              image: NetworkImage('https://i.pravatar.cc/150?img=26'),
              fit: BoxFit.cover, // Memastikan gambar memenuhi area bulat tanpa gepeng
            ),
          ),
        ),
        
        const SizedBox(height: 14), // Spasi antara Foto dan Teks Nama
        
        // Teks untuk menampilkan Nama Lengkap Petugas
        const Text(
          'Mutia Amelia',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w600, // Huruf dicetak tebal
            color: AppColors.textDark, // Warna gelap
          ),
        ),
        
        const SizedBox(height: 4), // Spasi kecil antara Nama dan Jabatan
        
        // Teks untuk menampilkan Jabatan/Posisi
        const Text(
          'Petugas Apotik',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w500, // Sedikit lebih tipis dari tebal (medium)
            color: AppColors.primaryLight, // Pakai warna primer versi cerah
          ),
        ),
      ],
    );
  }

  // =========================================================================
  // FUNGSI KHUSUS UNTUK MENAMPILKAN KOTAK INFORMASI PRIBADI (Email, Telp, dll)
  // =========================================================================
  Widget _buildInfoSection() {
    // Padding: Memberikan jarak batas tepi layar, di sini khusus batas kiri-kanan (horizontal) 16 pixel
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        // crossAxisAlignment.start: Memaksa semua elemen di dalam Column ini agar rapat ke kiri
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Teks judul "Informasi Pribadi" yang ada di atas kotak putih
          const Text(
            'Informasi Pribadi',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          
          const SizedBox(height: 12), // Jarak antara tulisan judul dan kotaknya
          
          // Container utama sebagai "Kotak Putih" yang membungkus daftar info
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface, // Background putih pada kotak
              borderRadius: BorderRadius.circular(12), // Supaya ke-4 ujung kotak jadi melengkung manis (tidak lancip)
              
              // Memberikan bayangan halus pada kotaknya
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04), // Bayangan sangat tipis (4%)
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            
            // Di dalam kotak putih, isinya berjejer vertikal ke bawah
            child: Column(
              children: [
                // Ini memanggil fungsi custom _infoRow (ada di bawah) berulang kali.
                // Ini berguna banget supaya kode kita tidak kepanjangan untuk hal yang polanya sama!
                
                // Baris ke-1: Email
                _infoRow(
                  icon: Icons.email_outlined, // Memakai icon Surat/Email
                  label: 'EMAIL',
                  value: 'mutia.amelia@viamedika.com',
                  divider: true, // Berikan garis pemisah tipis di bagian bawah baris ini
                ),
                
                // Baris ke-2: Nomor Telepon
                _infoRow(
                  icon: Icons.phone_outlined, // Memakai icon Telepon
                  label: 'NOMOR TELEPON',
                  value: '+62 812-3456-7890',
                  divider: true, // Berikan garis pemisah tipis
                ),
                
                // Baris ke-3: ID Pegawai
                _infoRow(
                  icon: Icons.badge_outlined, // Memakai icon Kartu Tanda Pengenal
                  label: 'ID PEGAWAI',
                  value: 'APT-PTG-001',
                  divider: false, // Tidak pakai garis karena ini item paling terakhir
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // FUNGSI BANTUAN UNTUK MENCETAK BARIS INFORMASI (Icon + Label + Isi data)
  // =========================================================================
  // Fungsi ini dipanggil berkali-kali di atas agar tidak perlu ketik ulang strukturnya
  Widget _infoRow({
    required IconData icon,   // Variabel yang meminta "Icon apa yang mau dipakai?"
    required String label,    // Variabel teks judul kecil ("EMAIL", dll)
    required String value,    // Variabel teks nilai datanya
    required bool divider,    // Variabel benar/salah (Apakah butuh dicetak garis bawahnya?)
  }) {
    return Column(
      children: [
        // Jarak dalam (padding) horizontal 16px dan atas-bawah 14px
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          
          // Row: Menyusun widget menyamping (kiri ke kanan) -> (Kotak Icon) [Spasi] (Teks Keterangan)
          child: Row(
            children: [
              // Kotak kecil dengan background abu-abu khusus untuk membungkus Icon
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.border, // Latar warna abu-abu pembatas
                  borderRadius: BorderRadius.circular(8), // Ujung melengkung
                ),
                // Icon(..) untuk menampilkan gambar icon-nya
                child: Icon(icon, color: AppColors.textSecondary, size: 20),
              ),
              
              const SizedBox(width: 14), // Jarak antara icon dan teks info
              
              // Expanded: Aturan Wajib saat kita pakai Row, agar teks di dalamnya
              // melebarkan diri mengambil sisa ruang yang ada, mencegah error layar kepotong/overflow
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Ratakan teks ke kiri
                  children: [
                    // Teks Label kecil di atas
                    Text(
                      label,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11, // Ukurannya imut (11px)
                        fontWeight: FontWeight.w600,
                        color: AppColors.textMuted, // Warna pucat
                        letterSpacing: 0.5, // Spasi tiap huruf agak direnggangkan biar estetik
                      ),
                    ),
                    
                    const SizedBox(height: 2), // Jarak super kecil antara Label dan Value
                    
                    // Teks Isi/Data Utamanya
                    Text(
                      value,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textDark, // Warna gelap tegas
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        // Aturan Logika If: Jika saat pemanggilan fungsi dia meminta `divider: true`,
        // maka Flutter akan menggambar garis pembatas (Divider) di bawah baris ini.
        if (divider)
          const Divider(
            height: 1, // Ketinggian keseluruhan garis
            thickness: 1, // Ketebalan tinta garis
            indent: 72, // Aturan Wajib: Mendorong garis 72 pixel dari kiri, supaya mulainya persis di bawah teks, bukan nabrak dari Icon!
            color: AppColors.border, // Warna garis pembatas abu-abu pudar
          ),
      ],
    );
  }

  // =========================================================================
  // FUNGSI UNTUK MENAMPILKAN TOMBOL KELUAR / LOGOUT
  // =========================================================================
  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      // Memberi jarak kiri-kanan agar tombol tidak mentok ke dinding layar HP
      padding: const EdgeInsets.symmetric(horizontal: 16),
      
      // SizedBox dengan width double.infinity digunakan untuk
      // "Memaksa lebar tombol sebesar-besarnya memenuhi layar sejauh batas Padding"
      child: SizedBox(
        width: double.infinity, 
        height: 52, // Menentukan tinggi tombol biar nyaman diklik sama jari (52px ideal)
        
        // ElevatedButton.icon: Widget tombol bawaan Flutter yang langsung nyediain slot Icon dan Label teks
        child: ElevatedButton.icon(
          
          // onPressed: Tombol ini fungsinya untuk apa?
          // Isinya adalah instruksi saat tombol diklik.
          // Navigator...pushNamedAndRemoveUntil digunakan untuk pindah ke halaman '/login',
          // DAN menghapus paksa seluruh riwayat halaman ("route => false"), jadi user gak bisa mencet tombol "Back" HP untuk balik ke dalam aplikasi kalau udah logout.
          onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false),
          
          // Ikon pintu panah (Logout) berwarna putih
          icon: const Icon(Icons.logout_rounded, color: Colors.white, size: 20),
          
          // Teks di dalam tombolnya
          label: const Text(
            'Keluar',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w500, // Cetak tebal
              color: Colors.white, // Huruf berwarna putih
            ),
          ),
          
          // style: Mengatur "baju" atau desain tampilannya tombol
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.danger, // Tombolnya dikasih warna merah (tanda peringatan/bahaya)
            elevation: 0, // Menghilangkan bayangan default tombol
            
            // shape: Membentuk ulang bentuk tombol
            // RoundedRectangleBorder supaya sudut-sudut tombol jadi melengkung 10 pixel (tidak kotak kaku)
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}
