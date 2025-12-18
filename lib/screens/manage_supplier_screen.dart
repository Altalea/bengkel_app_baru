import 'package:flutter/material.dart';
import '../database_helper.dart';
import '../supplier_model.dart';
import 'add_supplier_screen.dart';

class ManageSupplierScreen extends StatefulWidget {
  const ManageSupplierScreen({super.key});

  @override
  State<ManageSupplierScreen> createState() => _ManageSupplierScreenState();
}

class _ManageSupplierScreenState extends State<ManageSupplierScreen> {
  List<Supplier> _list = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    final data = await DatabaseHelper().getSuppliers();
    setState(() {
      _list = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Data Supplier")),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (c) => const AddSupplierScreen()));
          _refresh();
        },
      ),
      body: _isLoading ? const Center(child: CircularProgressIndicator()) : ListView.builder(
        itemCount: _list.length,
        itemBuilder: (context, index) {
          final item = _list[index];
          return ListTile(
            leading: const CircleAvatar(child: Icon(Icons.local_shipping)),
            title: Text(item.name),
            subtitle: Text("${item.phone} • ${item.category}"), // Tampilkan Kategori
          );
        },
      ),
    );
  }
}