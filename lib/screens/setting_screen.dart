import 'package:flutter/material.dart';
import 'login_page.dart'; // Pastikan import ini benar agar bisa Logout

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  // Variabel untuk menyimpan status switch (sementara)
  bool _isDarkMode = false;
  bool _isNotifEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Pengaturan"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black, // Warna teks & icon hitam
        elevation: 0.5,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // --- HEADER PROFIL (Hiasan) ---
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange.shade100),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.orange,
                  child: Icon(Icons.person, size: 35, color: Colors.white),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("User Bengkel", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text("user@bengkel.com", style: TextStyle(color: Colors.grey)),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 30),

          // --- BAGIAN 1: TAMPILAN ---
          const Text("Tampilan", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
          const Divider(),

          // Switch Dark Mode
          SwitchListTile(
            activeColor: Colors.orange,
            title: const Text("Mode Gelap"),
            subtitle: const Text("Ganti tema aplikasi ke gelap"),
            value: _isDarkMode,
            onChanged: (val) {
              setState(() {
                _isDarkMode = val;
              });
              // Catatan: Ini baru switch visual saja.
              // Untuk mengubah seluruh warna aplikasi, perlu coding di main.dart (nanti kita bahas)
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Mode Gelap: ${val ? 'ON' : 'OFF'} (Visual Switch)")),
              );
            },
            secondary: Icon(Icons.dark_mode, color: Colors.grey[700]),
          ),

          const SizedBox(height: 20),

          // --- BAGIAN 2: UMUM ---
          const Text("Umum", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
          const Divider(),

          ListTile(
            leading: Icon(Icons.notifications, color: Colors.grey[700]),
            title: const Text("Notifikasi"),
            trailing: Switch(
              activeColor: Colors.orange,
              value: _isNotifEnabled,
              onChanged: (val) => setState(() => _isNotifEnabled = val),
            ),
          ),
          ListTile(
            leading: Icon(Icons.language, color: Colors.grey[700]),
            title: const Text("Bahasa"),
            subtitle: const Text("Indonesia"),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.info_outline, color: Colors.grey[700]),
            title: const Text("Tentang Aplikasi"),
            subtitle: const Text("Versi 1.0.0"),
            onTap: () {},
          ),

          const SizedBox(height: 40),

          // --- TOMBOL KELUAR (LOGOUT) ---
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () {
                // Tampilkan dialog konfirmasi sebelum logout
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Konfirmasi"),
                    content: const Text("Yakin ingin keluar dari aplikasi?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context), // Batal
                        child: const Text("Batal"),
                      ),
                      TextButton(
                        onPressed: () {
                          // Aksi Logout: Kembali ke Login Page & Hapus history
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginPage()),
                                (route) => false,
                          );
                        },
                        child: const Text("Ya, Keluar", style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.logout, color: Colors.white),
              label: const Text("KELUAR APLIKASI", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}