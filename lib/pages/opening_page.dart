import 'package:flutter/material.dart';

// ===== HALAMAN SPLASH SCREEN =====
// Halaman pembuka aplikasi yang tampil pertama kali saat aplikasi dibuka
// Menampilkan logo dan nama rumah sakit dengan animasi fade in
// Setelah 3 detik, otomatis berpindah ke halaman login

class OpeningPage extends StatefulWidget {
  const OpeningPage({super.key});

  @override
  State<OpeningPage> createState() => _OpeningPageState();
}

class _OpeningPageState extends State<OpeningPage>
    with SingleTickerProviderStateMixin {
  // ===== VARIABEL STATE =====
  // Controller untuk mengatur jalannya animasi fade in
  late AnimationController _animationController;
  
  // Objek animasi yang mengatur nilai opacity dari 0.0 (transparan) ke 1.0 (penuh)
  late Animation<double> _fadeAnimation;

  // ===== METODE LIFECYCLE =====
  @override
  void initState() {
    super.initState();
    
    // Inisialisasi controller animasi dengan durasi 1.5 detik
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    // Membuat animasi fade dari transparan (0.0) ke penuh (1.0)
    // Menggunakan kurva easeIn agar animasi terasa halus dan natural
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
    
    // Menjalankan animasi fade in saat halaman pertama kali dibuka
    _animationController.forward();
    
    // Menunggu 3 detik lalu berpindah ke halaman berikutnya
    _navigateKeHalamanBerikutnya();
  }

  @override
  void dispose() {
    // Membersihkan controller animasi saat halaman dihancurkan
    // Penting untuk mencegah memory leak
    _animationController.dispose();
    super.dispose();
  }

  // ===== FUNGSI PEMBANTU =====
  // Fungsi untuk menunda navigasi selama 3 detik lalu pindah ke halaman login
  Future<void> _navigateKeHalamanBerikutnya() async {
    await Future.delayed(const Duration(seconds: 3));
    
    // Memastikan widget masih aktif sebelum melakukan navigasi
    if (!mounted) return;
    
    // Ganti '/login' dengan nama route halaman login kamu
    Navigator.pushReplacementNamed(context, '/login');
  }

  // ===== PEMBANGUN UI =====
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menghilangkan status bar agar tampilan lebih imersif
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // --- LAYER 1: Background Gradient ---
          // Gambar background tanpa logo yang mengisi seluruh layar
          Positioned.fill(
            child: Image.asset(
              'asset/image/Opening-1.png', // Background polos tanpa logo
              fit: BoxFit.cover, // Memastikan gambar memenuhi seluruh layar
            ),
          ),
          
          // --- LAYER 2: Logo dengan Animasi Fade In ---
          // Logo muncul di atas background dengan efek fade in
          Positioned.fill(
            child: FadeTransition(
              opacity: _fadeAnimation, // Menghubungkan animasi ke widget ini
              // Gambar logo + teks "Rumah Sakit Viamedika"
              child: Image.asset(
                'asset/image/Opening.png', // Gambar dengan logo di tengah
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
