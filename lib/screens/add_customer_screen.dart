import 'package:flutter/material.dart';
import '../database_helper.dart';
import '../customer_model.dart';

class AddCustomerScreen extends StatefulWidget {
  const AddCustomerScreen({super.key});

  @override
  State<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _vehicleController = TextEditingController(); // KHUSUS: Plat Nomor

  Future<void> _saveCustomer() async {
    // Validasi: Nama, HP, dan Plat Nomor wajib diisi
    if (_nameController.text.isEmpty || _mobileController.text.isEmpty || _vehicleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama, No HP, dan Plat Nomor wajib diisi!'), backgroundColor: Colors.red),
      );
      return;
    }

    final newCustomer = Customer(
      name: _nameController.text,
      mobile: _mobileController.text,
      email: _emailController.text,
      address: _addressController.text,
      vehicleNumber: _vehicleController.text,
    );

    await DatabaseHelper().insertCustomer(newCustomer);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pelanggan berhasil disimpan!'), backgroundColor: Colors.green),
    );
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Add Customer", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Icon User Biru
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(color: Colors.blue.shade50, shape: BoxShape.circle),
              child: const Icon(Icons.person_pin, size: 40, color: Colors.blue),
            ),
            const SizedBox(height: 20),

            _buildTextField("Customer Name*", "Nama Pelanggan", _nameController),
            _buildTextField("Mobile Number*", "Nomor HP", _mobileController, isNumber: true),

            // Kolom Khusus Plat Nomor (Dibuat menonjol)
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Vehicle Number (Plat Nomor)*", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                  TextField(
                    controller: _vehicleController,
                    decoration: const InputDecoration(
                      hintText: "Contoh: B 1234 XYZ",
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            _buildTextField("Email Address", "Email Pelanggan", _emailController),
            _buildTextField("Address", "Alamat Lengkap", _addressController, maxLines: 2),

            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _saveCustomer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Warna Biru sesuai desain
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text("Save Customer", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint, TextEditingController controller, {int maxLines = 1, bool isNumber = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: isNumber ? TextInputType.phone : TextInputType.text,
            decoration: InputDecoration(border: InputBorder.none, hintText: hint, hintStyle: TextStyle(color: Colors.grey.shade400)),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}