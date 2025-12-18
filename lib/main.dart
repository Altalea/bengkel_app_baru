import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/login_page.dart'; // Kita arahkan ke file login dulu

void main() {
  runApp(const BengkelApp());
}

class BengkelApp extends StatelessWidget {
  const BengkelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bengkel App',
      theme: ThemeData(
        // Warna utama Orange sesuai request
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: Colors.white,
        // Font Poppins
        textTheme: GoogleFonts.poppinsTextTheme(),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold
          ),
        ),
      ),
      // PERUBAHAN DISINI: Masuk ke LoginPage dulu, bukan HomeScreen
      home: const LoginPage(),
    );
  }
}