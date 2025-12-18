import 'package:flutter/material.dart';
import '../database_helper.dart';
import '../customer_model.dart';

class AddCustomerScreen extends StatefulWidget {
  const AddCustomerScreen({super.key});

  @override
  State<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controller
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _vehicleController = TextEditingController();
  final _addressController = TextEditingController();

  Future<void> _saveCustomer() async {
    if (_formKey.currentState!.validate()) {
      final newCustomer = Customer(
        name: _nameController.text,
        phone: _phoneController.text,
        email: _emailController.text,
        vehicleNumber: _vehicleController.text, // Plat Nomor
        address: _addressController.text,
      );

      await DatabaseHelper().insertCustomer(newCustomer);
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Pelanggan")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(controller: _nameController, decoration: const InputDecoration(labelText: "Nama Pelanggan")),
              TextFormField(controller: _phoneController, decoration: const InputDecoration(labelText: "No HP"), keyboardType: TextInputType.phone),
              TextFormField(controller: _emailController, decoration: const InputDecoration(labelText: "Email")),
              TextFormField(controller: _vehicleController, decoration: const InputDecoration(labelText: "Nomor Plat Kendaraan")),
              TextFormField(controller: _addressController, decoration: const InputDecoration(labelText: "Alamat")),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _saveCustomer, child: const Text("SIMPAN"))
            ],
          ),
        ),
      ),
    );
  }
}