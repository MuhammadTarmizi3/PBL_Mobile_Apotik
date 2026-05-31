// ===== IMPORT LIBRARY =====
// Bagian ini berisi semua import yang dibutuhkan untuk halaman admin
// Penting untuk mengorganisir dependencies dan halaman-halaman admin

// Import library utama Flutter untuk komponen UI
import 'package:flutter/material.dart';
// Import library untuk menampilkan gambar SVG
import 'package:flutter_svg/flutter_svg.dart';
// Import file konfigurasi asset dan warna
import '../../utils/app_assets.dart';
import '../../utils/app_colors.dart';
// Import halaman-halaman yang akan ditampilkan dalam tab navigasi
import 'dashboard_admin_page.dart';
import 'obat_page.dart';
import 'profile_page.dart';

// ===== WIDGET UTAMA =====
// Bagian ini mendefinisikan widget utama halaman admin
// Penting sebagai container utama yang mengelola navigasi dan state halaman admin

// Widget halaman utama admin dengan navigasi tab
class MainAdminPage extends StatefulWidget {
  const MainAdminPage({super.key});

  @override
  State<MainAdminPage> createState() => _MainAdminPageState();
}

class _MainAdminPageState extends State<MainAdminPage> {
  // ===== VARIABEL STATE =====
  // Bagian ini berisi variabel-variabel yang menyimpan state halaman admin
  // Penting untuk mengelola tab aktif dan komunikasi dengan child widget
  
  // Variabel untuk menyimpan index tab yang sedang aktif
  int _selectedIndex = 0;
  // GlobalKey untuk mengakses state dari ObatAdminPage
  final GlobalKey<ObatAdminPageState> _obatKey = GlobalKey<ObatAdminPageState>();

  // ===== METODE LIFECYCLE =====
  // Bagian ini berisi method build untuk render UI
  // Penting karena method ini yang menggambar seluruh struktur halaman admin
  
  @override
  Widget build(BuildContext context) {
    // Scaffold sebagai kerangka dasar halaman
    return Scaffold(
      backgroundColor: AppColors.surface,
      // Conditional AppBar: tidak tampil di halaman Profile (index 2)
      appBar: _selectedIndex == 2 ? null : _buildAppBar(),
      // IndexedStack untuk menjaga state setiap tab tetap hidup
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          const DashboardAdminPage(), // Tab Dashboard
          ObatAdminPage(key: _obatKey), // Tab Obat dengan key untuk akses state
          const ProfileAdminPage(), // Tab Profile
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
      // FloatingActionButton hanya muncul di tab Obat (index 1)
      floatingActionButton: _selectedIndex == 1
          ? FloatingActionButton(
              onPressed: () => _obatKey.currentState?.navigasiTambahObat(),
              backgroundColor: AppColors.tealBright,
              shape: const CircleBorder(),
              child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
            )
          : null,
    );
  }

  // ===== PEMBANGUN UI =====
  // Bagian ini berisi fungsi-fungsi yang membangun komponen UI
  // Penting untuk memisahkan logika pembuatan UI agar kode lebih terstruktur

  // Fungsi untuk membangun AppBar dengan logo dan foto profil
  PreferredSizeWidget _buildAppBar() => AppBar(
    backgroundColor: AppColors.surface, elevation: 0, scrolledUnderElevation: 0,
    automaticallyImplyLeading: false, titleSpacing: 20, toolbarHeight: 64,
    shape: const Border(bottom: BorderSide(color: AppColors.border, width: 1)),
    title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      // Logo aplikasi di kiri
      SvgPicture.asset(AppAssets.logoUtamaLandscape, height: 50, fit: BoxFit.contain),
      // Foto profil di kanan
      const CircleAvatar(radius: 18, backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=26')),
    ]),
  );

  // Fungsi untuk membangun Bottom Navigation Bar dengan 3 menu
  Widget _buildBottomNav() {
    return Container(
      height: 78, // Tinggi container navigasi
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
      // Widget BottomNavigationBar untuk menu navigasi
      child: BottomNavigationBar(
        currentIndex: _selectedIndex, // Index tab yang aktif
        // Fungsi yang dipanggil saat user tap menu
        onTap: (index) {
          setState(() {
            _selectedIndex = index; // Mengubah tab aktif
          });
        },
        backgroundColor: AppColors.surface,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
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
            icon: _navIcon(Icons.medication_rounded, 1), // Icon Obat
            label: 'Obat',
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
  // Bagian ini berisi fungsi-fungsi helper untuk komponen UI
  // Penting untuk membuat komponen reusable dengan animasi

  // Fungsi untuk membuat icon navigasi dengan animasi dan background saat aktif
  Widget _navIcon(IconData icon, int index) {
    final bool active = _selectedIndex == index; // Cek apakah icon ini sedang aktif

    // AnimatedContainer untuk animasi perubahan background
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220), // Durasi animasi
      curve: Curves.easeInOut, // Kurva animasi yang smooth
      padding: const EdgeInsets.all(8),
      // Dekorasi background yang berubah saat aktif
      decoration: BoxDecoration(
        color: active
            ? AppColors.primary.withValues(alpha: 0.12) // Background biru transparan saat aktif
            : Colors.transparent, // Transparan saat tidak aktif
        borderRadius: BorderRadius.circular(12),
      ),
      // AnimatedScale untuk efek zoom saat icon aktif
      child: AnimatedScale(
        duration: const Duration(milliseconds: 220),
        scale: active ? 1.1 : 1.0, // Scale 1.1x saat aktif
        child: Icon(
          icon,
          size: 22,
          color: active ? AppColors.primary : AppColors.textMuted, // Warna berubah sesuai status
        ),
      ),
    );
  }
}