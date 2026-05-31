// ===== IMPORT LIBRARY =====
// Bagian ini berisi import library Flutter
// Penting untuk menggunakan tipe data Color

// Import library Flutter untuk tipe data Color
import 'package:flutter/material.dart';

// ===== KONFIGURASI WARNA =====
// Bagian ini berisi definisi semua warna yang digunakan dalam aplikasi
// Penting untuk konsistensi desain dan memudahkan perubahan tema secara global

// Class yang menyimpan konstanta warna untuk seluruh aplikasi
class AppColors {
  // ===== WARNA BRAND (SERI TEAL) =====
  // Bagian ini berisi warna-warna utama brand aplikasi
  // Penting untuk identitas visual dan konsistensi brand
  
  static const Color primary = Color(0xFF005461); // Teal Gelap (Utama)
  static const Color primaryLight = Color(0xFF0D9488); // Teal Sedang (Tombol/Icon)
  static const Color accent = Color(0xFF14B8A6); // Teal Terang
  static const Color mint = Color(0xFF89F5E9); // Hijau Mint Muda
  static const Color teal = Color(0xFF249E94); // Teal untuk card/status
  static const Color mintDark = Color(0xFF3BC1A8); // Hijau Mint Gelap

  // ===== WARNA BACKGROUND & SURFACE =====
  // Bagian ini berisi warna untuk latar belakang dan permukaan komponen
  // Penting untuk menciptakan hierarki visual dan kedalaman UI
  
  static const Color background = Color(0xFFF0FDFA); // Putih Teal (Sangat Segar)
  static const Color backgroundAlt = Color(0xFFF5F5F5); // Background sekunder
  static const Color surface = Color(0xFFFFFFFF); // Putih Bersih
  static const Color neutral = Color(0xFFD9D9D9); // Abu-abu (Border/Disabled)
  static const Color border = Color(0xFFF0F0F0); // Garis batas tipis
  static const Color borderDark = Color(0xFFCCCCCC); // Garis batas tebal

  // ===== WARNA TEKS =====
  // Bagian ini berisi warna untuk berbagai jenis teks
  // Penting untuk keterbacaan dan hierarki informasi
  
  static const Color textDark = Color(0xFF1A1A1A); // Hampir Hitam (Teks Utama)
  static const Color textDarkAlt = Color(0xFF333333); // Abu-abu tua
  static const Color textDarker = Color(0xFF444444); // Abu-abu agak tua
  static const Color textDeepGreen = Color(0xFF114232); // Hijau Sangat Tua (Heading)
  static const Color textSecondary = Color(0xFF555555); // Teks sekunder
  static const Color textMuted = Color(0xFF888888); // Teks pudar
  static const Color textHint = Color(0xFFAAAAAA); // Placeholder

  // ===== WARNA FUNGSIONAL / STATUS =====
  // Bagian ini berisi warna untuk status dan feedback
  // Penting untuk komunikasi visual status dan peringatan
  
  static const Color danger = Color(0xFFBA1A1A); // Merah (Untuk Tombol 'Skip' atau Error)
  static const Color red = Color(0xFFB91C1C); // Merah Resep
  static const Color warning = Color(0xFFF4A640); // Kuning/Oranye peringatan

  // ===== WARNA TAMBAHAN =====
  // Bagian ini berisi warna-warna pendukung lainnya
  // Penting untuk variasi desain dan kebutuhan spesifik komponen
  
  static const Color lightCyan = Color(0xFF87C6D5); // Biru muda/cyan untuk teks
  static const Color slateGrey = Color(0xFF64748B); // Abu-abu kebiruan untuk teks
  static const Color lightestGrey = Color(0xFFF8FAFC); // Putih kebiruan sangat terang
  static const Color darkGrey = Color(0xFF333333); // Abu-abu tua untuk teks
  static const Color grey = Color(0xFF555555); // Abu-abu untuk teks
  static const Color lightGrey = Color(0xFFAAAAAA); // Abu-abu untuk hint
  static const Color borderGrey = Color(0xFFCCCCCC); // Abu-abu untuk border
  static const Color borderLight = Color(0xFFDDDDDD); // Abu-abu terang untuk border
  static const Color borderLighter = Color(0xFFE0E0E0); // Abu-abu lebih terang untuk border
  static const Color backgroundLight = Color(0xFFF5F5F5); // Abu-abu sangat terang
  static const Color backgroundPale = Color(0xFFF1F5F9); // Abu-abu pucat untuk border
  static const Color backgroundMint = Color(0xFFF8FAFA); // Putih kehijauan
  static const Color tealBright = Color(0xFF3AC0A8); // Hijau tosca terang
  static const Color tealDark = Color(0xFF006A63); // Teal gelap
  static const Color navy = Color(0xFF003B45); // Navy/teal sangat gelap
  static const Color tealMedium = Color(0xFF007169); // Teal medium
  static const Color pureRed = Color(0xFFFF0000); // Merah murni untuk error
}
