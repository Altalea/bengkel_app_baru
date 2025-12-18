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
  List<Customer> _customerList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _refreshList();
  }

  Future<void> _refreshList() async {
    final data = await DatabaseHelper().getCustomers();
    setState(() {
      _customerList = data;
      _isLoading = false;
    });
  }

  Future<void> _navigateToAdd() async {
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => const AddCustomerScreen()));
    if (result == true) _refreshList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("My Customers", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
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
                label: const Text("Add Customer", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _customerList.isEmpty
                  ? const Center(child: Text("Belum ada pelanggan."))
                  : ListView.builder(
                itemCount: _customerList.length,
                itemBuilder: (context, index) {
                  final c = _customerList[index];
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue.shade100,
                        child: const Icon(Icons.person, color: Colors.blue, size: 20),
                      ),
                      title: Text(c.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text("Plat: ${c.vehicleNumber}\nHP: ${c.mobile}"), // Menampilkan Plat Nomor
                      isThreeLine: true,
                      trailing: const Icon(Icons.message, color: Colors.green), // Ikon Chat
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