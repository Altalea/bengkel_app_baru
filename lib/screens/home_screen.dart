import 'package:flutter/material.dart';
import 'manage_shop_screen.dart';
import 'manage_employee_screen.dart';
import 'manage_package_screen.dart';
import 'manage_customer_screen.dart';
import 'manage_supplier_screen.dart';
import 'setting_screen.dart';
import 'add_transaction_screen.dart';
import 'history_screen.dart';

class HomeScreen extends StatefulWidget {
  final String role;
  final String username; // BARU: Variabel untuk menampung nama user asli

  // Kita tambahkan parameter username di sini
  const HomeScreen({
    super.key,
    this.role = 'Owner',
    this.username = 'Admin' // Default nama kalau kosong
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

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
            // Tampilkan Nama User Asli di sini biar kelihatan kita login sebagai siapa
            Text("Halo, ${widget.username} (${widget.role})", style: const TextStyle(fontSize: 12)),
          ],
        ),
        actions: [IconButton(icon: const Icon(Icons.settings), onPressed: _navigateToSettings)],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(12)),
              child: Text(
                widget.role == 'Pelanggan'
                    ? "Halo ${widget.username}, cek riwayat servismu!"
                    : "Dashboard Bengkel",
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: GridView.count(
                crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16,
                children: [
                  if (widget.role != 'Pelanggan')
                    _buildMenuCard(context, icon: Icons.point_of_sale, title: "Kasir / Transaksi", isDark: isDark,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => AddTransactionScreen(mechanicName: widget.username))), // Kirim nama user sbg mekanik
                    ),

                  // KIRIM username ASLI KE SINI
                  _buildMenuCard(context, icon: Icons.history, title: widget.role == 'Pelanggan' ? "Riwayat Servis" : "Laporan Transaksi", isDark: isDark,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => HistoryScreen(role: widget.role, userName: widget.username))),
                  ),

                  _buildMenuCard(context, icon: Icons.build, title: "Jasa & Harga", isDark: isDark,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => ManagePackageScreen(role: widget.role))),
                  ),

                  if (widget.role == 'Owner') ...[
                    _buildMenuCard(context, icon: Icons.store, title: "Toko", isDark: isDark, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const ManageShopScreen()))),
                    _buildMenuCard(context, icon: Icons.people, title: "Pegawai", isDark: isDark, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const ManageEmployeeScreen()))),
                    _buildMenuCard(context, icon: Icons.person_outline, title: "Data Pelanggan", isDark: isDark, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const ManageCustomerScreen()))),
                    _buildMenuCard(context, icon: Icons.local_shipping, title: "Supplier", isDark: isDark, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const ManageSupplierScreen()))),
                  ],

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