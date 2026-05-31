// ===== IMPORT LIBRARY =====
// Bagian ini berisi semua import yang dibutuhkan untuk aplikasi
// Penting untuk mengorganisir dependencies dan halaman-halaman utama

// Import library utama Flutter untuk komponen UI
import 'package:flutter/material.dart';
// Import file konfigurasi warna aplikasi
import 'utils/app_colors.dart';
// Import halaman-halaman yang akan digunakan dalam routing
import 'pages/opening_page.dart';
import 'pages/login/login_page.dart';
import 'pages/petugas/main_petugas_page.dart';
import 'pages/admin/main_admin_page.dart';

// ===== FUNGSI UTAMA =====
// Bagian ini berisi entry point aplikasi
// Penting karena ini adalah fungsi pertama yang dijalankan saat aplikasi dimulai

// Fungsi main sebagai entry point aplikasi Flutter
void main() {
  // Memastikan binding Flutter sudah diinisialisasi sebelum runApp
  WidgetsFlutterBinding.ensureInitialized();
  // Menjalankan aplikasi dengan widget MyApp sebagai root
  runApp(const MyApp());
}

// ===== WIDGET APLIKASI UTAMA =====
// Bagian ini mendefinisikan widget root aplikasi
// Penting sebagai container utama yang mengatur tema, routing, dan konfigurasi global

// Widget utama aplikasi yang mengatur konfigurasi global
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // ===== METODE LIFECYCLE =====
  // Bagian ini berisi method build untuk render UI
  // Penting karena method ini yang menggambar seluruh struktur aplikasi
  
  @override
  Widget build(BuildContext context) {
    // MaterialApp sebagai root widget yang mengatur tema dan routing
    return MaterialApp(
      title: 'Apotik Kelompok 4', // Judul aplikasi
      debugShowCheckedModeBanner: false, // Menyembunyikan banner debug
      // Konfigurasi tema aplikasi
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary), // Skema warna dari primary color
        useMaterial3: true, // Menggunakan Material Design 3
        fontFamily: 'Poppins', // Font default aplikasi
      ),
      initialRoute: '/', // Route awal saat aplikasi dibuka
      // Daftar route yang tersedia dalam aplikasi
      routes: {
        '/': (_) => const OpeningPage(), // Route untuk halaman opening/splash screen
        '/login': (_) => const LoginScreen(), // Route untuk halaman login
        '/petugas': (_) => const MainPetugasPage(), // Route untuk halaman petugas
        '/admin': (_) => const MainAdminPage(), // Route untuk halaman admin
      },
    );
  }
}
