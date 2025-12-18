import 'package:flutter/material.dart';
import '../database_helper.dart';
import '../package_model.dart';
import '../customer_model.dart';
import '../transaction_model.dart';

class AddTransactionScreen extends StatefulWidget {
  final String mechanicName; // Nama mekanik yang login
  const AddTransactionScreen({super.key, required this.mechanicName});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  // Data dari Database
  List<Customer> _customers = [];
  List<Package> _packages = []; // Daftar Barang/Jasa

  // Data Pilihan
  String? _selectedCustomerName;
  Package? _selectedPackageToAdd;

  // Keranjang Belanja
  final List<Package> _cart = [];
  double _totalPrice = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final c = await DatabaseHelper().getCustomers();
    final p = await DatabaseHelper().getPackages();
    setState(() {
      _customers = c;
      _packages = p;
    });
  }

  void _addToCart() {
    if (_selectedPackageToAdd != null) {
      setState(() {
        _cart.add(_selectedPackageToAdd!);
        _totalPrice += _selectedPackageToAdd!.price;
      });
    }
  }

  Future<void> _saveTransaction() async {
    if (_selectedCustomerName == null || _cart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Pilih Pelanggan & Barang dulu!")));
      return;
    }

    // Gabungkan nama barang jadi satu string (misal: "Oli, Ban")
    String itemsString = _cart.map((e) => e.name).join(", ");
    String dateNow = DateTime.now().toString().split(' ')[0]; // Ambil tanggal hari ini

    final newTrx = TransactionModel(
      customerName: _selectedCustomerName!,
      mechanicName: widget.mechanicName, // Diambil dari siapa yang login
      date: dateNow,
      items: itemsString,
      totalPrice: _totalPrice,
    );

    await DatabaseHelper().insertTransaction(newTrx);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Transaksi Berhasil Disimpan!")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kasir / Transaksi Baru")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 1. PILIH PELANGGAN
            DropdownButtonFormField<String>(
              hint: const Text("Pilih Pelanggan"),
              value: _selectedCustomerName,
              items: _customers.map((c) => DropdownMenuItem(value: c.name, child: Text(c.name))).toList(),
              onChanged: (val) => setState(() => _selectedCustomerName = val),
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),

            // 2. PILIH BARANG
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<Package>(
                    hint: const Text("Pilih Jasa/Barang"),
                    value: _selectedPackageToAdd,
                    items: _packages.map((p) => DropdownMenuItem(value: p, child: Text("${p.name} - Rp ${p.price}"))).toList(),
                    onChanged: (val) => setState(() => _selectedPackageToAdd = val),
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(onPressed: _addToCart, child: const Text("TAMBAH")),
              ],
            ),
            const SizedBox(height: 20),

            // 3. DAFTAR BELANJA (KERANJANG)
            const Text("Daftar Item:", style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: _cart.length,
                itemBuilder: (context, index) {
                  final item = _cart[index];
                  return ListTile(
                    title: Text(item.name),
                    trailing: Text("Rp ${item.price}"),
                    leading: const Icon(Icons.check_circle, color: Colors.green, size: 16),
                  );
                },
              ),
            ),

            const Divider(),
            // 4. TOTAL & SIMPAN
            Text("TOTAL: Rp ${_totalPrice.toStringAsFixed(0)}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orange)),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _saveTransaction,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text("SIMPAN TRANSAKSI", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}