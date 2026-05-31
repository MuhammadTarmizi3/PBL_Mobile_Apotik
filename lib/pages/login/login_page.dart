// ===== IMPORT LIBRARY =====
// Bagian ini berisi semua import yang dibutuhkan untuk halaman login
// Penting untuk mengorganisir dependencies dan komponen UI

// Import library utama Flutter untuk komponen UI
import 'package:flutter/material.dart';
// Import library untuk menampilkan gambar SVG
import 'package:flutter_svg/flutter_svg.dart';
// Import file konfigurasi asset dan warna
import '../../utils/app_assets.dart';
import '../../utils/app_colors.dart';

// ===== WIDGET UTAMA =====
// Bagian ini mendefinisikan widget utama halaman login
// Penting sebagai container utama yang mengelola state form login

// Widget halaman login dengan state management
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // ===== VARIABEL STATE =====
  // Bagian ini berisi variabel-variabel yang menyimpan state halaman login
  // Penting untuk mengelola input user dan kondisi form
  
  // Controller untuk input email
  final TextEditingController _emailController = TextEditingController();
  // Controller untuk input password
  final TextEditingController _passwordController = TextEditingController();
  // State untuk toggle visibility password
  bool _isPasswordVisible = false;
  // State untuk checkbox "Ingatkan saya"
  bool _rememberMe = false;

  // ===== METODE LIFECYCLE =====
  // Bagian ini berisi method lifecycle Flutter
  // Penting untuk manajemen memori dan cleanup resources
  
  // Method dispose untuk membersihkan controller saat widget dihapus
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Method build untuk menggambar UI halaman login
  @override
  Widget build(BuildContext context) {
    // Scaffold sebagai kerangka dasar halaman
    return Scaffold(
      backgroundColor: AppColors.surface,
      // SafeArea untuk menghindari area notch/status bar
      body: SafeArea(
        // SingleChildScrollView agar konten bisa di-scroll jika keyboard muncul
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              // Logo aplikasi di bagian atas
              Center(
                child: SvgPicture.asset(
                  AppAssets.logoUtamaLandscape,
                  height: 75,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 70),
              // Judul halaman login
              const Center(
                child: Text(
                  'Masuk Sebagai Karyawan',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                    height: 1.3,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // ===== FORM INPUT EMAIL =====
              // Label untuk input email
              const Text(
                'Alamat Email',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkGrey,
                ),
              ),
              const SizedBox(height: 10),
              // TextField untuk input email
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.darkGrey,
                ),
                decoration: InputDecoration(
                  hintText: 'Masukkan Email Anda',
                  hintStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: AppColors.lightGrey,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: AppColors.borderGrey,
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: AppColors.accent,
                      width: 1.5,
                    ),
                  ),
                  filled: true,
                  fillColor: AppColors.surface,
                ),
              ),
              const SizedBox(height: 24),

              // ===== FORM INPUT PASSWORD =====
              // Label untuk input password
              const Text(
                'Kata Sandi',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkGrey,
                ),
              ),
              const SizedBox(height: 10),
              // TextField untuk input password dengan toggle visibility
              TextField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.darkGrey,
                ),
                decoration: InputDecoration(
                  hintText: 'Masukkan kata sandi',
                  hintStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: AppColors.lightGrey,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  // Icon button untuk toggle visibility password
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: AppColors.accent,
                      size: 22,
                    ),
                    onPressed: () => setState(
                      () => _isPasswordVisible = !_isPasswordVisible,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: AppColors.borderGrey,
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: AppColors.accent,
                      width: 1.5,
                    ),
                  ),
                  filled: true,
                  fillColor: AppColors.surface,
                ),
              ),
              const SizedBox(height: 12),

              // ===== LINK LUPA PASSWORD =====
              // Tombol untuk fitur lupa kata sandi
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'Lupa Kata Sandi',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.accent,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ===== CHECKBOX REMEMBER ME =====
              // Checkbox untuk opsi "Ingatkan saya"
              Row(
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: Checkbox(
                      value: _rememberMe,
                      activeColor: AppColors.accent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3),
                      ),
                      side: const BorderSide(
                        color: AppColors.lightGrey,
                        width: 1.5,
                      ),
                      onChanged: (value) =>
                          setState(() => _rememberMe = value ?? false),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Ingatkan saya',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDarker,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // ===== TOMBOL MASUK =====
              // Tombol untuk submit form login dan validasi kredensial
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    final email = _emailController.text;
                    final password = _passwordController.text;

                    // Validasi kredensial dan navigasi ke halaman sesuai role
                    if (email == 'admin' && password == 'admin123') {
                      Navigator.pushReplacementNamed(context, '/admin');
                    } else if (email == 'petugas' && password == 'petugas123') {
                      Navigator.pushReplacementNamed(context, '/petugas');
                    } else {
                      // Tampilkan pesan error jika kredensial salah
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Email atau password salah'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.surface,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Masuk',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
