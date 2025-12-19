import 'package:flutter/material.dart';
import '../database_helper.dart'; // Import Database
import 'home_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _selectedRole = 'Owner';
  final List<String> _roles = ['Owner', 'Mekanik', 'Pelanggan'];

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Isi Username & Password!")));
      return;
    }

    setState(() => _isLoading = true);

    // CEK KE DATABASE
    final user = await DatabaseHelper().loginUser(
        _usernameController.text,
        _passwordController.text,
        _selectedRole
    );

    setState(() => _isLoading = false);

    if (user != null) {
      // Login Sukses!
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            role: _selectedRole,
            username: user['name'],
          ),
        ),
      );
    } else {
      // Login Gagal
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login Gagal! Username/Password Salah.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // KODE BARU (yang sudah diganti)
                Container(
                  padding: const EdgeInsets.all(20), // Padding bisa disesuaikan atau dihapus
                  decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      shape: BoxShape.circle
                  ),
                  // Gunakan Image.asset untuk menampilkan gambarmu
                  child: Image.asset(
                    'assets/login_logo.png', // <-- Pastikan path-nya benar
                    width: 100,              // Atur lebar gambar
                    height: 100,             // Atur tinggi gambar
                    fit: BoxFit.contain,     // Agar gambar tidak terpotong
                  ),
                ),
                const SizedBox(height: 20),
                const Text("BENGKEL PRO", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
                const SizedBox(height: 10),
                const Text("Silakan masuk untuk melanjutkan", style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 40),

                DropdownButtonFormField<String>(
                  value: _selectedRole,
                  decoration: InputDecoration(
                    labelText: "Masuk Sebagai",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.badge),
                  ),
                  items: _roles.map((String value) => DropdownMenuItem(value: value, child: Text(value))).toList(),
                  onChanged: (newValue) => setState(() => _selectedRole = newValue!),
                ),
                const SizedBox(height: 20),

                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: "Username",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.lock),
                  ),
                ),
                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("MASUK", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
                // Kode Text contekan password di sini sudah dihapus
              ],
            ),
          ),
        ),
      ),
    );
  }
}