import 'package:flutter/material.dart';
import 'pages/login/login_page.dart';
import 'pages/petugas/main_petugas_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Apotik Kelompok 4',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF005461)),
        useMaterial3: true,
        fontFamily: 'Poppins',
      ),
      initialRoute: '/login',
      routes: {
        '/login':   (_) => const LoginScreen(),
        '/petugas': (_) => const MainPetugasPage(),
      },
    );
  }
}