import 'package:flutter/material.dart';
// import 'dart:io'; // <--- HAPUS BARIS INI (PENYEBAB CRASH)
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
    try {
      final data = await DatabaseHelper().getEmployees();
      setState(() {
        _employeeList = data;
        _isLoading = false;
      });
    } catch (e) {
      print("Error: $e");
      setState(() => _isLoading = false);
    }
  }

  Future<void> _navigateToAdd() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddEmployeeScreen()),
    );
    // Refresh kalau habis nambah data
    if (result == true) { // Pastikan AddScreen mengembalikan true saat pop
      _refreshEmployeeList();
    } else {
      // Jaga-jaga refresh manual juga
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
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),

              // --- PERBAIKAN GAMBAR (AMAN UNTUK WEB) ---
              leading: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.blue[100],
                // Kita pakai Inisial Nama atau Icon Orang
                child: Text(
                  emp.name.isNotEmpty ? emp.name[0].toUpperCase() : '?',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.blueAccent
                  ),
                ),
              ),

              title: Text(emp.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  // Tampilkan Jabatan
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(5)
                    ),
                    child: Text(
                        emp.position,
                        style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 12)
                    ),
                  ),
                  const SizedBox(height: 5),
                  // Tampilkan No HP
                  Row(
                    children: [
                      const Icon(Icons.phone, size: 14, color: Colors.grey),
                      const SizedBox(width: 5),
                      Text(emp.phone, style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
              // Tombol Hapus (Sementara dummy dulu sesuai permintaan)
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.grey),
                onPressed: () {
                  // Nanti diisi kalau butuh
                },
              ),
            ),
          );
        },
      ),
    );
  }
}