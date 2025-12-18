import 'package:flutter/material.dart';
import '../database_helper.dart';
import '../employee_model.dart';

class AddEmployeeScreen extends StatefulWidget {
  const AddEmployeeScreen({super.key});
  @override
  State<AddEmployeeScreen> createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _posController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passController = TextEditingController(); // Controller Password

  String _selectedRole = 'Mekanik'; // Default

  Future<void> _saveEmployee() async {
    if (_formKey.currentState!.validate()) {
      final newEmp = Employee(
        name: _nameController.text,
        position: _selectedRole,
        phone: _phoneController.text,
        imagePath: '',
        password: _passController.text, // Simpan Password
      );
      await DatabaseHelper().insertEmployee(newEmp);
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Pegawai")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(controller: _nameController, decoration: const InputDecoration(labelText: "Nama Pegawai")),
              const SizedBox(height: 10),
              // Pilihan Role (Biar gak salah ketik)
              DropdownButtonFormField<String>(
                value: _selectedRole,
                items: ['Mekanik', 'Owner'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) => setState(() => _selectedRole = val!),
                decoration: const InputDecoration(labelText: "Jabatan"),
              ),
              TextFormField(controller: _phoneController, decoration: const InputDecoration(labelText: "No HP"), keyboardType: TextInputType.phone),
              const SizedBox(height: 10),
              // Input Password
              TextFormField(
                controller: _passController,
                decoration: const InputDecoration(labelText: "Password Login"),
                obscureText: true, // Biar titik-titik
                validator: (val) => val!.isEmpty ? "Password harus diisi" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _saveEmployee, child: const Text("SIMPAN"))
            ],
          ),
        ),
      ),
    );
  }
}