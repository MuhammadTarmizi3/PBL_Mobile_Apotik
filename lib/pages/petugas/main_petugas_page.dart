// ===== IMPORT LIBRARY =====
// Bagian ini berisi semua import yang dibutuhkan untuk halaman ini
// Penting untuk mengorganisir dependencies dan memastikan semua komponen tersedia

// Aturan Wajib Flutter: Library material.dart ini wajib di-import 
// karena hampir semua komponen UI (seperti Scaffold, AppBar) ada di sini.
import 'package:flutter/material.dart';

// Import untuk bisa menampilkan gambar berformat vektor (.svg)
import 'package:flutter_svg/flutter_svg.dart';

// Import file yang berisi daftar lokasi gambar/asset kita
import '../../utils/app_assets.dart';
// Import file daftar warna buatan kita sendiri
import '../../utils/app_colors.dart';

// Meng-import halaman-halaman yang akan dipasang di dalam tab navigasi bawah
import 'dashboard_petugas_page.dart';
import 'eresep_page.dart';
import 'profile_page.dart';

// ===== WIDGET UTAMA =====
// Bagian ini mendefinisikan widget utama halaman petugas
// Penting sebagai container utama yang mengelola navigasi dan state halaman

/// Shell utama untuk seluruh navigasi petugas.
/// Mengelola AppBar, BottomNav, dan IndexedStack antar tab.
// StatefulWidget: Halaman yang datanya dinamis (bisa berubah). 
// Di sini kita butuh StatefulWidget karena kita perlu mengganti-ganti tampilan tab (state).
class MainPetugasPage extends StatefulWidget {
  // Aturan Wajib: super.key untuk identifikasi unik widget ini
  const MainPetugasPage({super.key});

  @override
  State<MainPetugasPage> createState() => _MainPetugasPageState();
}

class _MainPetugasPageState extends State<MainPetugasPage> {
  // ===== VARIABEL STATE =====
  // Bagian ini berisi variabel-variabel yang menyimpan state/kondisi halaman
  // Penting untuk mengelola perubahan tampilan dan interaksi user
  
  // Variabel untuk menyimpan tab mana yang sedang aktif (0: Dashboard, 1: E-Resep, 2: Profile)
  int _selectedIndex = 0;

  // Daftar halaman/tab yang akan ditampilkan. Harus const (tetap) agar lebih hemat memori
  static const List<Widget> _pages = [
    DashboardPetugasPage(),
    EResepPage(),
    ProfilePage(),
  ];

  // ===== METODE LIFECYCLE =====
  // Bagian ini berisi method build yang merupakan lifecycle utama Flutter
  // Penting karena method ini yang menggambar/render seluruh tampilan UI
  
  // Aturan Wajib: build() adalah fungsi untuk menggambar/me-render tampilan
  @override
  Widget build(BuildContext context) {
    // Scaffold: Kerangka dasar halaman Flutter yang menyediakan struktur AppBar, Body, dan BottomNav
    return Scaffold(
      // Mengatur warna latar belakang halaman
      backgroundColor: AppColors.surface,
      
      // Jika tab yang aktif adalah tab ke-2 (Profile), maka JANGAN tampilkan AppBar (null).
      // Jika tab lain (0 atau 1), tampilkan fungsi _buildAppBar().
      appBar: _selectedIndex == 2 ? null : _buildAppBar(), 
      
      // body adalah bagian isi utama. 
      // IndexedStack: Menumpuk halaman-halaman, tapi yang dimunculkan cuma satu sesuai dengan `_selectedIndex`.
      // Kenapa pakai IndexedStack? Supaya waktu kita ganti tab, halaman sebelumnya tidak ter-reset/refresh ulang (statenya tetap terjaga).
      body: IndexedStack(index: _selectedIndex, children: _pages),
      
      // Menampilkan menu navigasi di bawah layar
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ===== PEMBANGUN UI =====
  // Bagian ini berisi fungsi-fungsi yang membangun komponen UI
  // Penting untuk memisahkan logika pembuatan UI agar kode lebih terstruktur dan mudah dipelihara

  // ── Fungsi untuk menggambar AppBar (Header atas) ──────────────────────────
  // Membangun AppBar dengan logo dan foto profil
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.surface, // Warna background atas (putih)
      elevation: 0, // Menghilangkan garis bayangan
      scrolledUnderElevation: 0, // Mencegah warna berubah saat di-scroll
      automaticallyImplyLeading: false, // Menghapus tombol panah back bawaan
      titleSpacing: 20, // Memberi jarak tepi untuk judul
      toolbarHeight: 64, // Tinggi AppBar disesuaikan (agak tinggi)
      
      // Membuat garis bawah yang tipis untuk batas AppBar
      shape: const Border(
        bottom: BorderSide(color: AppColors.border, width: 1),
      ),
      
      // Isi konten AppBar (kiri: Logo, kanan: Foto Profil)
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Agar logo dan profil saling berjauhan (rata ujung kiri dan kanan)
        children: [
          // SvgPicture untuk menampilkan logo format .svg
          SvgPicture.asset(
            AppAssets.logoUtamaLandscape,
            height: 50,
            fit: BoxFit.contain,
          ),
          
          // CircleAvatar untuk membuat gambar profil jadi bulat sempurna
          const CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=26'),
          ),
        ],
      ),
    );
  }

  // ── Bottom Navigation Bar ─────────────────────────────────────
  // Membangun navigasi bawah dengan 3 menu: Dashboard, E-Resep, Profile
  Widget _buildBottomNav() {
    return Container(
      height: 78, // Tinggi container navigasi bawah
      // Dekorasi untuk membuat border atas
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(
            color: AppColors.border,
            width: 1,
          ),
        ),
      ),
      // Widget BottomNavigationBar untuk menampilkan menu navigasi
      child: BottomNavigationBar(
        currentIndex: _selectedIndex, // Index tab yang sedang aktif
        // Fungsi yang dipanggil saat user tap salah satu menu
        onTap: (index) {
          setState(() {
            _selectedIndex = index; // Mengubah tab aktif
          });
        },
        backgroundColor: AppColors.surface, // Warna background navigasi
        elevation: 0, // Menghilangkan bayangan
        type: BottomNavigationBarType.fixed, // Tipe fixed agar semua item terlihat
        selectedItemColor: AppColors.primary, // Warna item yang dipilih
        unselectedItemColor: AppColors.textMuted, // Warna item yang tidak dipilih
        // Style untuk label item yang dipilih
        selectedLabelStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        // Style untuk label item yang tidak dipilih
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 12,
        ),
        // Daftar item menu navigasi
        items: [
          BottomNavigationBarItem(
            icon: _navIcon(Icons.grid_view_rounded, 0), // Icon Dashboard
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: _navIcon(Icons.receipt_long_rounded, 1), // Icon E-Resep
            label: 'E-Resep',
          ),
          BottomNavigationBarItem(
            icon: _navIcon(Icons.person_outline_rounded, 2), // Icon Profile
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  // ===== FUNGSI PEMBANTU =====
  // Bagian ini berisi fungsi-fungsi helper yang mendukung UI
  // Penting untuk membuat komponen yang reusable dan menambah interaktivitas

  // ── Custom Icon Navbar ────────────────────────────────────────
  // Membuat icon navigasi dengan animasi dan background saat aktif
  Widget _navIcon(IconData icon, int index) {
    final bool active = _selectedIndex == index; // Cek apakah icon ini sedang aktif

    // AnimatedContainer untuk membuat animasi perubahan background
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220), // Durasi animasi
      curve: Curves.easeInOut, // Kurva animasi yang smooth
      padding: const EdgeInsets.all(8), // Padding dalam icon
      // Dekorasi background yang berubah saat aktif
      decoration: BoxDecoration(
        color: active
            ? AppColors.primary.withValues(alpha: 0.12) // Background biru transparan saat aktif
            : Colors.transparent, // Transparan saat tidak aktif
        borderRadius: BorderRadius.circular(12), // Sudut melengkung
      ),
      // AnimatedScale untuk membuat efek zoom saat icon aktif
      child: AnimatedScale(
        duration: const Duration(milliseconds: 220), // Durasi animasi
        scale: active ? 1.1 : 1.0, // Scale 1.1x saat aktif, 1.0x saat tidak
        child: Icon(
          icon,
          size: 22, // Ukuran icon
          color: active ? AppColors.primary : AppColors.textMuted, // Warna berubah sesuai status
        ),
      ),
    );
  }
}
