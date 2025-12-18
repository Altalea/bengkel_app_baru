import 'package:flutter/material.dart';
import '../database_helper.dart';
import '../customer_model.dart';
import 'add_customer_screen.dart';

class ManageCustomerScreen extends StatefulWidget {
  const ManageCustomerScreen({super.key});

  @override
  State<ManageCustomerScreen> createState() => _ManageCustomerScreenState();
}

class _ManageCustomerScreenState extends State<ManageCustomerScreen> {
  List<Customer> _list = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    final data = await DatabaseHelper().getCustomers();
    setState(() {
      _list = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Data Pelanggan")),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (c) => const AddCustomerScreen()));
          _refresh();
        },
      ),
      body: _isLoading ? const Center(child: CircularProgressIndicator()) : ListView.builder(
        itemCount: _list.length,
        itemBuilder: (context, index) {
          final item = _list[index];
          return ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text(item.name),
            subtitle: Text("${item.phone}\n${item.vehicleNumber}"), // Tampilkan Plat Nomor
            isThreeLine: true,
          );
        },
      ),
    );
  }
}