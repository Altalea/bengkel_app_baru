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
  List<Supplier> _supplierList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _refreshList();
  }

  Future<void> _refreshList() async {
    final data = await DatabaseHelper().getSuppliers();
    setState(() {
      _supplierList = data;
      _isLoading = false;
    });
  }

  Future<void> _navigateToAdd() async {
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => const AddSupplierScreen()));
    if (result == true) _refreshList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("My Supplier", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () => Navigator.pop(context)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity, height: 50,
              child: ElevatedButton.icon(
                onPressed: _navigateToAdd,
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text("Add Supplier", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _supplierList.isEmpty
                  ? const Center(child: Text("Belum ada supplier."))
                  : ListView.builder(
                itemCount: _supplierList.length,
                itemBuilder: (context, index) {
                  final s = _supplierList[index];
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.red.shade100,
                        child: const Icon(Icons.inventory, color: Colors.redAccent, size: 20),
                      ),
                      title: Text(s.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text("${s.category} • ${s.mobile}"),
                      trailing: const Icon(Icons.phone, color: Colors.green),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}