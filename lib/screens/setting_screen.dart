import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../theme_manager.dart'; // Remote Tema
import 'login_page.dart';

class SettingScreen extends StatefulWidget {
  final String currentRole; // Menerima role dari Home

  const SettingScreen({super.key, required this.currentRole});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  // Data Profil Sementara (Nanti bisa pakai Database/SharedPref)
  String _userName = "User Bengkel";
  File? _profileImage;
  bool _isNotifEnabled = true;

  // Fungsi Ganti Foto
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  // Fungsi Edit Nama (Dialog)
  void _editName() {
    TextEditingController nameController = TextEditingController(text: _userName);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Ganti Nama"),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(hintText: "Masukkan nama baru"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _userName = nameController.text;
              });
              Navigator.pop(context);
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: themeNotifier,
      builder: (context, isDark, child) {
        return Scaffold(
          appBar: AppBar(title: const Text("Pengaturan")),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // --- 1. PROFIL SECTION (Bisa Ganti Foto & Nama) ---
              Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey[300],
                            backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                            child: _profileImage == null
                                ? const Icon(Icons.person, size: 50, color: Colors.grey)
                                : null,
                          ),
                          Positioned(
                            bottom: 0, right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
                              child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _userName,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit, size: 18, color: Colors.orange),
                          onPressed: _editName,
                        ),
                      ],
                    ),
                    Text(
                      "Role: ${widget.currentRole}", // Menampilkan Role
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // --- 2. MENU KHUSUS (Berbeda Tiap Role) ---
              if (widget.currentRole == 'Owner') ...[
                const Text("Menu Pemilik", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                const ListTile(
                  leading: Icon(Icons.backup),
                  title: Text("Backup Data"),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                ),
                const ListTile(
                  leading: Icon(Icons.attach_money),
                  title: Text("Laporan Keuangan"),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                ),
              ] else if (widget.currentRole == 'Mekanik') ...[
                const Text("Menu Mekanik", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                const ListTile(
                  leading: Icon(Icons.schedule),
                  title: Text("Jadwal Shift"),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                ),
              ],

              const Divider(),

              // --- 3. PENGATURAN UMUM ---
              const Text("Umum", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),

              // Switch Dark Mode
              SwitchListTile(
                title: const Text("Mode Gelap"),
                secondary: Icon(Icons.dark_mode, color: isDark ? Colors.white : Colors.grey),
                value: isDark,
                activeColor: Colors.orange,
                onChanged: (val) {
                  themeNotifier.value = val;
                },
              ),

              // Switch Notifikasi
              SwitchListTile(
                title: const Text("Notifikasi"),
                subtitle: const Text("Info servis & promo"),
                secondary: Icon(Icons.notifications, color: isDark ? Colors.white : Colors.grey),
                value: _isNotifEnabled,
                activeColor: Colors.orange,
                onChanged: (val) {
                  setState(() {
                    _isNotifEnabled = val;
                  });
                },
              ),

              // Versi Aplikasi
              ListTile(
                leading: Icon(Icons.info_outline, color: isDark ? Colors.white : Colors.grey),
                title: const Text("Versi Aplikasi"),
                trailing: const Text("v1.0.0", style: TextStyle(color: Colors.grey)),
              ),

              const SizedBox(height: 20),

              // --- 4. LOGOUT ---
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    themeNotifier.value = false; // Reset tema
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                          (route) => false,
                    );
                  },
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: const Text("KELUAR", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}