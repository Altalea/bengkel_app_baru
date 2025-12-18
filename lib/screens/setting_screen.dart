import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../theme_manager.dart';
import '../database_helper.dart';
import 'login_page.dart';

class SettingScreen extends StatefulWidget {
  final String currentRole;
  final String currentUsername;

  const SettingScreen({
    super.key,
    required this.currentRole,
    this.currentUsername = 'Admin',
  });

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  File? _profileImage;

  // Fungsi Ganti Foto (Lokal sementara)
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  // Fungsi Ganti Password
  void _showChangePasswordDialog() {
    final passController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Ganti Password"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Masukkan password baru anda:"),
              const SizedBox(height: 10),
              TextField(
                controller: passController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password Baru",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (passController.text.isNotEmpty) {
                  await DatabaseHelper().changePassword(
                      widget.currentUsername,
                      widget.currentRole,
                      passController.text
                  );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Password Berhasil Diubah!")),
                  );
                }
              },
              child: const Text("Simpan"),
            ),
          ],
        );
      },
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
              // --- PROFIL ---
              Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                        child: _profileImage == null
                            ? const Icon(Icons.person, size: 50, color: Colors.grey)
                            : null,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.currentUsername,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Role: ${widget.currentRole}",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // --- KEAMANAN ---
              const Text("Keamanan", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
              ListTile(
                leading: Icon(Icons.lock_reset, color: isDark ? Colors.white : Colors.black),
                title: const Text("Ganti Password"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: _showChangePasswordDialog,
              ),
              const Divider(),

              // --- MENU KHUSUS OWNER ---
              if (widget.currentRole == 'Owner') ...[
                const Text("Menu Pemilik", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                const ListTile(
                  leading: Icon(Icons.backup), title: Text("Backup Data"),
                ),
              ],
              const Divider(),

              // --- UMUM ---
              const Text("Umum", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
              SwitchListTile(
                title: const Text("Mode Gelap"),
                secondary: Icon(Icons.dark_mode, color: isDark ? Colors.white : Colors.grey),
                value: isDark,
                activeColor: Colors.orange,
                onChanged: (val) {
                  themeNotifier.value = val;
                },
              ),

              const SizedBox(height: 20),

              // --- LOGOUT ---
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    themeNotifier.value = false;
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                          (route) => false,
                    );
                  },
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: const Text("KELUAR", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}