import 'package:flutter/material.dart';
import 'dart:io';                  // Untuk menangani File gambar
import 'package:image_picker/image_picker.dart'; // Wajib ada di pubspec.yaml
import '../database_helper.dart';  // Import Database (naik 1 folder)
import '../shop_model.dart';       // Import Model (naik 1 folder)

class AddShopScreen extends StatefulWidget {
  const AddShopScreen({super.key});

  @override
  State<AddShopScreen> createState() => _AddShopScreenState();
}

class _AddShopScreenState extends State<AddShopScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controller Text
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _ownerController = TextEditingController();

  // Variable Dropdown & Gambar
  String _selectedType = 'Bengkel Mobil';
  final List<String> _types = ['Bengkel Mobil', 'Bengkel Motor', 'Toko Sparepart'];

  File? _selectedImage; // Untuk menampung foto yang dipilih

  // Fungsi Ambil Gambar
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  // Fungsi Simpan Data
  Future<void> _saveShop() async {
    if (_formKey.currentState!.validate()) {
      // 1. Buat object Shop baru
      final newShop = Shop(
        shopName: _nameController.text,
        address: _addressController.text,
        ownerName: _ownerController.text,
        type: _selectedType,
        imagePath: _selectedImage?.path, // Simpan path gambar (bisa null kalau gak pilih foto)
      );

      // 2. Simpan ke Database
      await DatabaseHelper().insertShop(newShop);

      // 3. Kembali ke layar sebelumnya & kasih info sukses
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Toko berhasil disimpan!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Toko Baru")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // --- AREA UPLOAD FOTO ---
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: _selectedImage != null
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(_selectedImage!, fit: BoxFit.cover),
                  )
                      : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.camera_alt, size: 50, color: Colors.grey),
                      Text("Ketuk untuk upload logo"),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // --- INPUT NAMA TOKO ---
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Nama Bengkel", border: OutlineInputBorder()),
                validator: (val) => val!.isEmpty ? "Harap isi nama bengkel" : null,
              ),
              const SizedBox(height: 16),

              // --- INPUT ALAMAT ---
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: "Alamat", border: OutlineInputBorder()),
                validator: (val) => val!.isEmpty ? "Harap isi alamat" : null,
              ),
              const SizedBox(height: 16),

              // --- INPUT OWNER ---
              TextFormField(
                controller: _ownerController,
                decoration: const InputDecoration(labelText: "Nama Pemilik", border: OutlineInputBorder()),
                validator: (val) => val!.isEmpty ? "Harap isi nama pemilik" : null,
              ),
              const SizedBox(height: 16),

              // --- DROPDOWN TIPE ---
              DropdownButtonFormField<String>(
                value: _selectedType,
                items: _types.map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
                onChanged: (val) => setState(() => _selectedType = val!),
                decoration: const InputDecoration(labelText: "Tipe Bengkel", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 24),

              // --- TOMBOL SIMPAN ---
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveShop,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange),
                  child: const Text("SIMPAN TOKO", style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}