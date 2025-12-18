import 'package:flutter/material.dart';
import '../database_helper.dart';
import '../package_model.dart';

class AddPackageScreen extends StatefulWidget {
  const AddPackageScreen({super.key});

  @override
  State<AddPackageScreen> createState() => _AddPackageScreenState();
}

class _AddPackageScreenState extends State<AddPackageScreen> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descController = TextEditingController();

  Future<void> _savePackage() async {
    // Validasi: Nama dan Harga wajib diisi
    if (_nameController.text.isEmpty || _priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama Paket dan Harga wajib diisi!'), backgroundColor: Colors.red),
      );
      return;
    }

    final newPackage = Package(
      packageName: _nameController.text,
      price: _priceController.text,
      description: _descController.text,
    );

    await DatabaseHelper().insertPackage(newPackage);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Paket Servis berhasil disimpan!'), backgroundColor: Colors.green),
    );
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Add Package", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
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
            // Icon Kado/Paket Besar
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(color: Colors.purple.shade50, shape: BoxShape.circle),
              child: const Icon(Icons.card_giftcard, size: 40, color: Colors.purple),
            ),
            const SizedBox(height: 20),

            _buildTextField("Package Name*", "Nama Paket (Cth: Paket Ganti Oli)", _nameController),
            _buildTextField("Price*", "Harga (Cth: Rp 150.000)", _priceController, isNumber: true),
            _buildTextField("Description", "Keterangan (Apa saja yang didapat)", _descController, maxLines: 3),

            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _savePackage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple, // Warna Ungu biar beda
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text("Save Package", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
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
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            decoration: InputDecoration(border: InputBorder.none, hintText: hint, hintStyle: TextStyle(color: Colors.grey.shade400)),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}