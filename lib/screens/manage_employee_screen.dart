import 'package:flutter/material.dart';
import 'dart:io';
import '../database_helper.dart';
import '../employee_model.dart';
import 'add_employee_screen.dart';

class ManageEmployeeScreen extends StatefulWidget {
  const ManageEmployeeScreen({super.key});

  @override
  State<ManageEmployeeScreen> createState() => _ManageEmployeeScreenState();
}

class _ManageEmployeeScreenState extends State<ManageEmployeeScreen> {
  List<Employee> _employeeList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _refreshEmployeeList();
  }

  Future<void> _refreshEmployeeList() async {
    // Pastikan fungsi getEmployees() ada di DatabaseHelper kamu
    final data = await DatabaseHelper().getEmployees();
    setState(() {
      _employeeList = data;
      _isLoading = false;
    });
  }

  Future<void> _navigateToAdd() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddEmployeeScreen()),
    );
    if (result == true) {
      _refreshEmployeeList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(title: const Text("Kelola Pegawai")),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAdd,
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _employeeList.isEmpty
          ? const Center(child: Text("Belum ada pegawai."))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _employeeList.length,
        itemBuilder: (context, index) {
          final emp = _employeeList[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              // --- MENAMPILKAN FOTO PEGAWAI ---
              leading: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey[200],
                backgroundImage: (emp.imagePath != null && File(emp.imagePath!).existsSync())
                    ? FileImage(File(emp.imagePath!))
                    : null,
                child: (emp.imagePath == null || !File(emp.imagePath!).existsSync())
                    ? const Icon(Icons.person, size: 30)
                    : null,
              ),
              title: Text(emp.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(emp.position, style: const TextStyle(color: Colors.blue)),
                  Text(emp.phone, style: const TextStyle(fontSize: 12)),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  // Tambahkan fungsi hapus nanti jika perlu
                },
              ),
            ),
          );
        },
      ),
    );
  }
}