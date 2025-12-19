import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../theme_manager.dart'; // Import ThemeManager Baru
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

  // --- FUNGSI GANTI NAMA (EDIT PROFIL) ---
  void _showEditNameDialog() {
    final nameController = TextEditingController(text: widget.currentUsername);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Ganti Nama"),
        content: TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: "Nama Baru")
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty) {
                // Update ke Database
                await DatabaseHelper().updateUsername(
                    widget.currentUsername,
                    nameController.text,
                    widget.currentRole
                );

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Nama berhasil diubah! Silakan Login Ulang."))
                );

                // Langsung logout biar refresh
                Future.delayed(const Duration(seconds: 1), () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                        (route) => false,
                  );
                });
              }
            },
            child: const Text("Simpan"),
          )
        ],
      ),
    );
  }

  // Fungsi Ganti Password
  void _showChangePasswordDialog() {
    final passController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Ganti Password"),
          content: TextField(
            controller: passController,
            obscureText: true,
            decoration: const InputDecoration(labelText: "Password Baru"),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
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
                      const SnackBar(content: Text("Password Berhasil Diubah!"))
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
    return AnimatedBuilder(
      animation: themeManager,
      builder: (context, child) {
        bool isDark = themeManager.isDark;

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

                    // Baris Nama + Tombol Edit
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.currentUsername,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit, size: 18, color: Colors.blue),
                          onPressed: _showEditNameDialog, // Klik untuk ganti nama
                          tooltip: "Ganti Nama",
                        ),
                      ],
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

              // --- UMUM ---
              const Text("Umum", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
              SwitchListTile(
                title: const Text("Mode Gelap"),
                secondary: Icon(Icons.dark_mode, color: isDark ? Colors.white : Colors.grey),
                value: isDark,
                activeColor: Colors.orange,
                onChanged: (val) {
                  themeManager.toggleTheme(val); // SIMPAN PERMANEN
                },
              ),

              const SizedBox(height: 20),

              // --- LOGOUT ---
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Reset ke halaman login
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