import 'package:flutter/material.dart';
import 'login_page.dart';

// --- BAGIAN BARU: IMPORT HALAMAN TUJUAN ---
// Pastikan nama file ini sesuai dengan yang ada di folder project kamu
import 'manage_shop_screen.dart';
import 'manage_employee_screen.dart';
import 'setting_screen.dart';
// ------------------------------------------

class HomeScreen extends StatefulWidget {
  final String userRole;

  const HomeScreen({super.key, required this.userRole});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    // Cek apakah user adalah Pemilik
    bool isOwner = widget.userRole == 'Pemilik';

    return Scaffold(
      appBar: AppBar(
        title: Text("Halo, ${widget.userRole}"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage())
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [

            // --- MENU 1: MANAGE SHOP ---
            if (isOwner)
              _buildMenuCard(
                icon: Icons.store,
                title: "Manage Shop",
                onTap: () {
                  // SEKARANG SUDAH NYAMBUNG KE HALAMAN ASLI
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ManageShopScreen())
                  );
                },
              ),

            // --- MENU 2: EMPLOYEE ---
            if (isOwner || widget.userRole == 'Mekanik')
              _buildMenuCard(
                icon: Icons.people,
                title: "Employee",
                onTap: () {
                  // NYAMBUNG KE HALAMAN EMPLOYEE
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ManageEmployeeScreen())
                  );
                },
              ),

            // --- MENU SETTINGS ---
            _buildMenuCard(
              icon: Icons.settings,
              title: "Settings",
              onTap: () {
                // NYAMBUNG KE HALAMAN SETTINGS
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SettingScreen())
                );
              },
            ),

            // Menu Riwayat (Contoh belum ada filenya, jadi kita kosongkan dulu navigasinya)
            _buildMenuCard(
              icon: Icons.history,
              title: "Riwayat",
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Fitur Riwayat belum dibuat"))
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard({required IconData icon, required String title, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.grey.shade200, blurRadius: 5, spreadRadius: 2)
            ],
            border: Border.all(color: Colors.orange.withOpacity(0.3))
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.orange),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}