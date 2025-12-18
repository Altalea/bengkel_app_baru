import 'package:flutter/material.dart';
import '../database_helper.dart';
import '../package_model.dart';

class AddPackageScreen extends StatefulWidget {
  const AddPackageScreen({super.key});

  @override
  State<AddPackageScreen> createState() => _AddPackageScreenState();
}

class _AddPackageScreenState extends State<AddPackageScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descController = TextEditingController();

  String _selectedType = 'Servis';
  final List<String> _types = ['Servis', 'Sparepart'];

  Future<void> _savePackage() async {
    if (_formKey.currentState!.validate()) {
      final newPackage = Package(
        name: _nameController.text, // PERBAIKAN DISINI
        price: double.parse(_priceController.text),
        type: _selectedType,
        description: _descController.text,
      );

      await DatabaseHelper().insertPackage(newPackage);

      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data berhasil disimpan!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Jasa / Barang")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Nama Jasa / Barang", border: OutlineInputBorder()),
                validator: (val) => val!.isEmpty ? "Harap isi nama" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Harga (Rp)", border: OutlineInputBorder()),
                validator: (val) => val!.isEmpty ? "Harap isi harga" : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedType,
                items: _types.map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
                onChanged: (val) => setState(() => _selectedType = val!),
                decoration: const InputDecoration(labelText: "Jenis", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: "Keterangan", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _savePackage,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  child: const Text("SIMPAN", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}