import 'package:flutter/material.dart';
import '../database_helper.dart';
import '../package_model.dart';
import 'add_package_screen.dart';

class ManagePackageScreen extends StatefulWidget {
  final String role; // Menerima Role agar tahu siapa yang login

  // Default 'Owner' biar aman
  const ManagePackageScreen({super.key, this.role = 'Owner'});

  @override
  State<ManagePackageScreen> createState() => _ManagePackageScreenState();
}

class _ManagePackageScreenState extends State<ManagePackageScreen> {
  List<Package> _packageList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _refreshList();
  }

  Future<void> _refreshList() async {
    final data = await DatabaseHelper().getPackages();
    setState(() {
      _packageList = data;
      _isLoading = false;
    });
  }

  Future<void> _deletePackage(int id) async {
    await DatabaseHelper().deletePackage(id);
    _refreshList();
  }

  Future<void> _navigateToAdd() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddPackageScreen()),
    );
    if (result == true) {
      _refreshList();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Cek apakah user adalah pelanggan
    bool isCustomer = widget.role == 'Pelanggan';

    return Scaffold(
      appBar: AppBar(title: const Text("Daftar Harga & Servis")),

      // JIKA PELANGGAN -> Tombol Tambah HILANG (null)
      floatingActionButton: isCustomer
          ? null
          : FloatingActionButton(
        onPressed: _navigateToAdd,
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add, color: Colors.white),
      ),

      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _packageList.isEmpty
          ? const Center(child: Text("Belum ada data."))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _packageList.length,
        itemBuilder: (context, index) {
          final item = _packageList[index];
          return Card(
            child: ListTile(
              leading: Icon(
                item.type == 'Servis' ? Icons.build : Icons.shopping_bag,
                color: Colors.orange,
              ),
              title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("${item.type} • ${item.description ?? '-'}"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Rp ${item.price.toStringAsFixed(0)}",
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                  // JIKA BUKAN PELANGGAN -> Munculkan Tombol Hapus
                  if (!isCustomer)
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                      onPressed: () => _deletePackage(item.id!),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}