import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme_manager.dart';            // Import Remote
import 'screens/login_page.dart';

void main() {
  runApp(const BengkelApp());
}

class BengkelApp extends StatelessWidget {
  const BengkelApp({super.key});

  @override
  Widget build(BuildContext context) {
    // PEMBUNGKUS UTAMA: Mendengarkan perubahan themeNotifier
    return ValueListenableBuilder<bool>(
      valueListenable: themeNotifier,
      builder: (context, isDark, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Bengkel App',

          // --- KONFIGURASI TEMA TERANG ---
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.orange,
            scaffoldBackgroundColor: Colors.white,
            textTheme: GoogleFonts.poppinsTextTheme(),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.black),
              titleTextStyle: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),

          // --- KONFIGURASI TEMA GELAP ---
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.orange,
            scaffoldBackgroundColor: const Color(0xFF121212),
            textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF1F1F1F),
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.white),
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: const Color(0xFF2C2C2C),
              labelStyle: const TextStyle(color: Colors.grey),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),

          // PENTING: Inilah yang menentukan aplikasi pakai baju yang mana
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,

          home: const LoginPage(),
        );
      },
    );
  }
}