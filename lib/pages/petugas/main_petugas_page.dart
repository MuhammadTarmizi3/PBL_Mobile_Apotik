import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../utils/app_assets.dart';
import '../../utils/app_colors.dart';
import 'dashboard_petugas_page.dart';
import 'eresep.dart';
import 'profile_page.dart';

/// Shell utama untuk seluruh navigasi petugas.
/// Mengelola AppBar, BottomNav, dan IndexedStack antar tab.
class MainPetugasPage extends StatefulWidget {
  const MainPetugasPage({super.key});

  @override
  State<MainPetugasPage> createState() => _MainPetugasPageState();
}

class _MainPetugasPageState extends State<MainPetugasPage> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = [
    DashboardPetugasPage(),
    EResepPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: _buildAppBar(),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ── AppBar tunggal untuk semua tab ─────────────────────────────────────────
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 20,
      toolbarHeight: 64,
      shape: const Border(bottom: BorderSide(color: Color(0xFFF0F0F0), width: 1)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SvgPicture.asset(AppAssets.logoUtamaLandscape, height: 32, fit: BoxFit.contain),
          const CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=26'),
          ),
        ],
      ),
    );
  }

  // ── BottomNav tunggal untuk semua tab ──────────────────────────────────────
  Widget _buildBottomNav() {
    return Container(
      height: 80,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: Color(0xFFF0F0F0), width: 1)),
      ),
      child: BottomNavigationBar(
        elevation: 0,
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 12),
        onTap: (index) => setState(() => _selectedIndex = index),
        items: [
          BottomNavigationBarItem(icon: _navIcon(Icons.grid_view_rounded, 0),       label: 'Dashboard'),
          BottomNavigationBarItem(icon: _navIcon(Icons.receipt_long_rounded, 1),    label: 'E-Resep'),
          BottomNavigationBarItem(icon: _navIcon(Icons.person_outline_rounded, 2),  label: 'Profile'),
        ],
      ),
    );
  }

  Widget _navIcon(IconData icon, int index) {
    final bool active = _selectedIndex == index;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: active ? AppColors.background : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: active ? AppColors.primaryLight : Colors.grey),
    );
  }
}