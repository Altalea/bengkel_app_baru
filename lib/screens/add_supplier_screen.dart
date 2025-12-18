import 'package:flutter/material.dart';
import '../database_helper.dart';
import '../supplier_model.dart';

class AddSupplierScreen extends StatefulWidget {
  const AddSupplierScreen({super.key});

  @override
  State<AddSupplierScreen> createState() => _AddSupplierScreenState();
}

class _AddSupplierScreenState extends State<AddSupplierScreen> {
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _categoryController = TextEditingController(); // Misal: Oli, Ban, Sparepart

  Future<void> _saveSupplier() async {
    if (_nameController.text.isEmpty || _mobileController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama dan No HP wajib diisi!'), backgroundColor: Colors.red),
      );
      return;
    }

    final newSupplier = Supplier(
      name: _nameController.text,
      mobile: _mobileController.text,
      email: _emailController.text,
      address: _addressController.text,
      category: _categoryController.text,
    );

    await DatabaseHelper().insertSupplier(newSupplier);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Supplier berhasil disimpan!'), backgroundColor: Colors.green),
    );
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Add Supplier", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
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
            // Icon Besar
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(color: Colors.red.shade50, shape: BoxShape.circle),
              child: const Icon(Icons.inventory, size: 40, color: Colors.redAccent),
            ),
            const SizedBox(height: 20),

            _buildTextField("Supplier Name*", "Nama Pemasok", _nameController),
            _buildTextField("Mobile Number*", "Nomor HP", _mobileController, isNumber: true),
            _buildTextField("Email", "Email Pemasok", _emailController),
            _buildTextField("Category", "Kategori (Misal: Ban/Oli)", _categoryController),
            _buildTextField("Address", "Alamat Lengkap", _addressController, maxLines: 2),

            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _saveSupplier,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent, // Warna merah sesuai desain
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text("Save Supplier", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
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