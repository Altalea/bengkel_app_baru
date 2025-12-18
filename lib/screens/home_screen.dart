import 'package:flutter/material.dart';
import 'manage_shop_screen.dart';
import 'manage_employee_screen.dart';
import 'manage_package_screen.dart';
import 'manage_customer_screen.dart';
import 'manage_supplier_screen.dart';
import 'setting_screen.dart'; // Pastikan import ini ada

class HomeScreen extends StatefulWidget {
  // Kita terima role dari halaman Login
  final String role;

  // Default role jika tidak dikirim adalah 'Owner' (biar aman)
  const HomeScreen({super.key, this.role = 'Owner'});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  // Fungsi Logout / Pindah ke Setting
  void _navigateToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingScreen(currentRole: widget.role),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Cek apakah sedang mode gelap
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Bengkel App", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("Halo, ${widget.role}", style: const TextStyle(fontSize: 12)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _navigateToSettings,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER SUMMARY (Opsional) ---
            Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "Selamat Datang di Dashboard!",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),

            const Text("Menu Utama", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),

            // --- GRID MENU ---
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  // Menu 1: Toko
                  _buildMenuCard(
                    context,
                    icon: Icons.store,
                    title: "Kelola Toko",
                    isDark: isDark,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const ManageShopScreen())),
                  ),
                  // Menu 2: Pegawai (Hanya Owner)
                  if (widget.role == 'Owner')
                    _buildMenuCard(
                      context,
                      icon: Icons.people,
                      title: "Pegawai",
                      isDark: isDark,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const ManageEmployeeScreen())),
                    ),
                  // Menu 3: Servis & Harga
                  _buildMenuCard(
                    context,
                    icon: Icons.build,
                    title: "Jasa & Harga",
                    isDark: isDark,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const ManagePackageScreen())),
                  ),
                  // Menu 4: Pelanggan
                  _buildMenuCard(
                    context,
                    icon: Icons.person_outline,
                    title: "Pelanggan",
                    isDark: isDark,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const ManageCustomerScreen())),
                  ),
                  // Menu 5: Supplier
                  _buildMenuCard(
                    context,
                    icon: Icons.local_shipping,
                    title: "Supplier",
                    isDark: isDark,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const ManageSupplierScreen())),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget Card Menu dengan Border yang Dinamis (Mengikuti Tema)
  Widget _buildMenuCard(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap, required bool isDark}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          // GANTI LOGIKANYA DI SINI:
          // Jika Dark Mode: Pakai warna kartu gelap. Jika Light: Putih.
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,

          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            // Border mengikuti tema: Abu gelap kalau dark mode, abu terang kalau light mode
            color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 32, color: Colors.orange),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                // Warna teks mengikuti tema otomatis
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}