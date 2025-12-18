import 'package:flutter/material.dart';
import '../database_helper.dart';
import '../transaction_model.dart';

class HistoryScreen extends StatefulWidget {
  final String role;
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
      final data = await DatabaseHelper().getTransactionsByCustomer(widget.userName);
      setState(() => _list = data);
    } else {
      final data = await DatabaseHelper().getTransactions();
      setState(() => _list = data);
    }
  }

  // Fungsi Ganti Status (Dialog)
  void _showStatusDialog(TransactionModel trx) {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text("Update Status Pengerjaan"),
          children: [
            _buildStatusOption(trx, "Menunggu", Colors.grey),
            _buildStatusOption(trx, "Sedang Dikerjakan", Colors.orange),
            _buildStatusOption(trx, "Selesai", Colors.green),
          ],
        );
      },
    );
  }

  Widget _buildStatusOption(TransactionModel trx, String status, Color color) {
    return SimpleDialogOption(
      onPressed: () async {
        await DatabaseHelper().updateTransactionStatus(trx.id!, status);
        Navigator.pop(context);
        _loadHistory(); // Refresh data
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Status diubah ke $status")));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(Icons.circle, color: color, size: 14),
            const SizedBox(width: 10),
            Text(status, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  // Warna status biar cantik
  Color _getStatusColor(String status) {
    if (status == 'Selesai') return Colors.green;
    if (status == 'Sedang Dikerjakan') return Colors.orange;
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.role == 'Pelanggan' ? "Riwayat & Tracking" : "Laporan Transaksi")),
      body: _list.isEmpty
          ? const Center(child: Text("Belum ada data."))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _list.length,
        itemBuilder: (context, index) {
          final trx = _list[index];

          // Logic: Kalau Mekanik/Owner -> Bisa diklik buat ganti status
          // Kalau Pelanggan -> Cuma lihat doang (null)
          return GestureDetector(
            onTap: (widget.role != 'Pelanggan')
                ? () => _showStatusDialog(trx)
                : null,

            child: Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header: Tanggal & Badge Status
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(trx.date, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getStatusColor(trx.status).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: _getStatusColor(trx.status)),
                          ),
                          child: Text(
                            trx.status.toUpperCase(),
                            style: TextStyle(
                              color: _getStatusColor(trx.status),
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(),

                    // Body: Nama & Item
                    Text(trx.customerName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text("Mekanik: ${trx.mechanicName}", style: const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 8),
                    Text(trx.items, style: const TextStyle(fontSize: 14)),
                    const SizedBox(height: 8),

                    // Footer: Harga
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Rp ${trx.totalPrice.toStringAsFixed(0)}",
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 16),
                      ),
                    ),

                    // Hint buat Mekanik
                    if (widget.role != 'Pelanggan')
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(
                          "Ketuk untuk update status",
                          style: TextStyle(fontSize: 10, color: Colors.grey, fontStyle: FontStyle.italic),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}