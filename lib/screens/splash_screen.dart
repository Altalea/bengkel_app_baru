import 'package:flutter/material.dart';
import 'dart:async';
import 'login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Tunggu 3 detik, lalu pindah ke Login
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Warna background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20), // Sesuaikan padding jika perlu
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              // Gunakan Image.asset:
              child: Image.asset(
                'assets/login_logo.png', // <-- Pakai gambar yang sama dengan login tadi
                width: 100,              // Atur ukuran agar pas di dalam lingkaran
                height: 100,
                fit: BoxFit.contain,
              ),
            ),
            // Nama Aplikasi
            const Text(
              "BENGKEL PRO",
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2
              ),
            ),
            const SizedBox(height: 10),
            const Text("Solusi Bengkel Terpercaya", style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 50),

            // Loading Muter-muter
            const CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}