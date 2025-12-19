import 'package:flutter/material.dart';
import '../database_helper.dart';
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

    final user = await DatabaseHelper().loginUser(
        _usernameController.text,
        _passwordController.text,
        _selectedRole
    );

    setState(() => _isLoading = false);

    if (user != null) {
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login Gagal! Username/Password Salah.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1. CEK APAKAH SEDANG DARK MODE?
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // 2. JANGAN PAKSA 'Colors.white'. Gunakan warna bawaan tema.
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo Container
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    // Warna lingkaran menyesuaikan tema (biar gak silau pas dark mode)
                      color: isDark ? Colors.orange.withOpacity(0.2) : Colors.orange.shade50,
                      shape: BoxShape.circle
                  ),
                  child: Image.asset(
                    'assets/login_logo.png',
                    width: 100,
                    height: 100,
                    fit: BoxFit.contain,
                    // Error builder buat jaga-jaga kalau gambar belum ada/error
                    errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.car_repair, size: 80, color: Colors.orange),
                  ),
                ),
                const SizedBox(height: 20),

                // Judul
                Text(
                    "BENGKEL PRO",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        // Warna teks otomatis (Putih di Dark, Hitam di Light)
                        color: isDark ? Colors.white : Colors.black87
                    )
                ),
                const SizedBox(height: 10),
                const Text("Silakan masuk untuk melanjutkan", style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 40),

                // Dropdown Role
                DropdownButtonFormField<String>(
                  value: _selectedRole,
                  decoration: InputDecoration(
                    labelText: "Masuk Sebagai",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.badge),
                  ),
                  items: _roles.map((String value) => DropdownMenuItem(value: value, child: Text(value))).toList(),
                  onChanged: (newValue) => setState(() => _selectedRole = newValue!),
                  // Pastikan dropdown pop-up warnanya benar
                  dropdownColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                ),
                const SizedBox(height: 20),

                // Input Username
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: "Username",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.person),
                  ),
                  // Teks input otomatis ikut tema
                ),
                const SizedBox(height: 16),

                // Input Password
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

                // Tombol Masuk
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}