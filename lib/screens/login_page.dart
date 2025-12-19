import 'package:flutter/material.dart';
import '../database_helper.dart';
import 'home_screen.dart'; // Dashboard Owner/Mekanik
import 'customer_dashboard.dart'; // Dashboard Pelanggan (BARU)

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
      // --- LOGIKA PEMISAH HALAMAN ---
      if (_selectedRole == 'Pelanggan') {
        // Pelanggan masuk ke halaman khusus (Booking & Katalog)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CustomerDashboard(
              username: user['name'],
            ),
          ),
        );
      } else {
        // Owner & Mekanik masuk ke halaman Admin (Laporan, Kasir, dll)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(
              role: _selectedRole,
              username: user['name'],
            ),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login Gagal! Username/Password Salah.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: isDark ? Colors.orange.withOpacity(0.2) : Colors.orange.shade50,
                      shape: BoxShape.circle
                  ),
                  child: Image.asset(
                    'assets/login_logo.png',
                    width: 100,
                    height: 100,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.car_repair, size: 80, color: Colors.orange),
                  ),
                ),
                const SizedBox(height: 20),

                Text(
                    "BENGKEL PRO",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87
                    )
                ),
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
                  dropdownColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}