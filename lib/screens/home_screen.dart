import 'package:flutter/material.dart';
import 'manage_shop_screen.dart';
import 'manage_employee_screen.dart';
import 'manage_package_screen.dart';
import 'manage_customer_screen.dart';
import 'manage_supplier_screen.dart';
import 'setting_screen.dart';
import 'add_transaction_screen.dart'; // Import Kasir
import 'history_screen.dart';         // Import Riwayat

class HomeScreen extends StatefulWidget {
  final String role;
  const HomeScreen({super.key, this.role = 'Owner'});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Kita simpan nama user sementara (Hardcode dulu sesuai role)
  // Nanti bisa diambil dari Login kalau sudah ada database User
  String get _currentUserName {
    if (widget.role == 'Pelanggan') return "Faatin"; // Ganti dengan nama tes kamu
    return "Admin";
  }

  void _navigateToSettings() {
    Navigator.push(context, MaterialPageRoute(builder: (c) => SettingScreen(currentRole: widget.role)));
  }

  @override
  Widget build(BuildContext context) {
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
        actions: [IconButton(icon: const Icon(Icons.settings), onPressed: _navigateToSettings)],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER ---
            Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(12)),
              child: Text(
                widget.role == 'Pelanggan' ? "Cek riwayat servismu disini!" : "Dashboard Bengkel",
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),

            // --- GRID MENU ---
            Expanded(
              child: GridView.count(
                crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16,
                children: [
                  // 1. TRANSAKSI BARU (Hanya Mekanik & Owner)
                  if (widget.role != 'Pelanggan')
                    _buildMenuCard(context, icon: Icons.point_of_sale, title: "Kasir / Transaksi", isDark: isDark,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => AddTransactionScreen(mechanicName: widget.role))), // Kirim role sbg nama mekanik sementara
                    ),

                  // 2. RIWAYAT SERVIS (Untuk SEMUA)
                  // Pelanggan lihat nota dia, Owner lihat laporan
                  _buildMenuCard(context, icon: Icons.history, title: widget.role == 'Pelanggan' ? "Riwayat Servis" : "Laporan Transaksi", isDark: isDark,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => HistoryScreen(role: widget.role, userName: _currentUserName))),
                  ),

                  // 3. JASA & HARGA (Katalog Read-Only buat Pelanggan)
                  _buildMenuCard(context, icon: Icons.build, title: "Jasa & Harga", isDark: isDark,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => ManagePackageScreen(role: widget.role))), // Kirim Role
                  ),

                  // 4. MENU KHUSUS OWNER
                  if (widget.role == 'Owner') ...[
                    _buildMenuCard(context, icon: Icons.store, title: "Toko", isDark: isDark, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const ManageShopScreen()))),
                    _buildMenuCard(context, icon: Icons.people, title: "Pegawai", isDark: isDark, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const ManageEmployeeScreen()))),
                    _buildMenuCard(context, icon: Icons.person_outline, title: "Data Pelanggan", isDark: isDark, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const ManageCustomerScreen()))),
                  ],

                  // 5. Data Pelanggan (Untuk Mekanik juga)
                  if (widget.role == 'Mekanik')
                    _buildMenuCard(context, icon: Icons.person_outline, title: "Data Pelanggan", isDark: isDark, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const ManageCustomerScreen()))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap, required bool isDark}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isDark ? Colors.grey[800]! : Colors.grey[200]!, width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: Colors.orange),
            const SizedBox(height: 12),
            Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}