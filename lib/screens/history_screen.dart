import 'package:flutter/material.dart';
import '../database_helper.dart';
import '../transaction_model.dart';

class HistoryScreen extends StatefulWidget {
  final String role;
  // Nama user yang login (diperlukan jika role == Pelanggan)
  final String userName;

  const HistoryScreen({super.key, required this.role, required this.userName});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<TransactionModel> _list = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    if (widget.role == 'Pelanggan') {
      // Pelanggan cuma bisa lihat data dia sendiri
      // Kita asumsikan 'userName' sama dengan nama di database customers
      // (Nanti kalau mau perfect, user login harus connect ke id customer, tapi ini cukup dulu)
      final data = await DatabaseHelper().getTransactionsByCustomer(widget.userName); // Filter by Name
      setState(() => _list = data);
    } else {
      // Owner/Mekanik lihat semua
      final data = await DatabaseHelper().getTransactions();
      setState(() => _list = data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.role == 'Pelanggan' ? "Riwayat Servis Saya" : "Laporan Transaksi")),
      body: _list.isEmpty
          ? const Center(child: Text("Belum ada riwayat servis."))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _list.length,
        itemBuilder: (context, index) {
          final trx = _list[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(trx.date, style: const TextStyle(color: Colors.grey)),
                      Text("Rp ${trx.totalPrice.toStringAsFixed(0)}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 16)),
                    ],
                  ),
                  const Divider(),
                  Text("Pelanggan: ${trx.customerName}", style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text("Mekanik: ${trx.mechanicName}"),
                  const SizedBox(height: 8),
                  const Text("Pengerjaan:", style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey)),
                  Text(trx.items, style: const TextStyle(fontSize: 15)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}