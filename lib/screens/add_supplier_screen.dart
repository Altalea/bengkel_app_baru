import 'package:flutter/material.dart';
import '../database_helper.dart';
import '../supplier_model.dart';

class AddSupplierScreen extends StatefulWidget {
  const AddSupplierScreen({super.key});

  @override
  State<AddSupplierScreen> createState() => _AddSupplierScreenState();
}

class _AddSupplierScreenState extends State<AddSupplierScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _categoryController = TextEditingController();
  final _addressController = TextEditingController();

  Future<void> _saveSupplier() async {
    if (_formKey.currentState!.validate()) {
      final newSupplier = Supplier(
        name: _nameController.text,
        phone: _phoneController.text,
        email: _emailController.text,
        category: _categoryController.text,
        address: _addressController.text,
      );

      await DatabaseHelper().insertSupplier(newSupplier);
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Supplier")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(controller: _nameController, decoration: const InputDecoration(labelText: "Nama Supplier")),
              TextFormField(controller: _phoneController, decoration: const InputDecoration(labelText: "No HP"), keyboardType: TextInputType.phone),
              TextFormField(controller: _emailController, decoration: const InputDecoration(labelText: "Email")),
              TextFormField(controller: _categoryController, decoration: const InputDecoration(labelText: "Kategori (Oli/Ban/Sparepart)")),
              TextFormField(controller: _addressController, decoration: const InputDecoration(labelText: "Alamat")),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _saveSupplier, child: const Text("SIMPAN"))
            ],
          ),
        ),
      ),
    );
  }
}