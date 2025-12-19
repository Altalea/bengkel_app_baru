import 'package:flutter/material.dart';
import '../database_helper.dart';

class NotificationScreen extends StatefulWidget {
  final String role;
  final String username;

  const NotificationScreen({super.key, required this.role, required this.username});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<Map<String, dynamic>> _notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    List<Map<String, dynamic>> tempNotifs = [];

    if (widget.role == 'Owner') {
      // 1. Cek Stok (Simulasi)
      tempNotifs.add({
        "title": "Peringatan Stok",
        "body": "Stok Oli dan Filter mulai menipis. Segera restock!",
        "icon": Icons.inventory,
        "color": Colors.red
      });
      // 2. Ringkasan Harian
      final trx = await DatabaseHelper().getTransactions();
      tempNotifs.add({
        "title": "Ringkasan Harian",
        "body": "Total ${trx.length} transaksi tercatat di sistem.",
        "icon": Icons.attach_money,
        "color": Colors.green
      });

    } else if (widget.role == 'Mekanik') {
      // Cek Pekerjaan Pending
      final trx = await DatabaseHelper().getTransactions();
      int pending = trx.where((t) => t.mechanicName == widget.username && t.status != 'Selesai').length;

      if (pending > 0) {
        tempNotifs.add({
          "title": "Tugas Baru",
          "body": "Anda memiliki $pending mobil yang belum selesai dikerjakan.",
          "icon": Icons.handyman,
          "color": Colors.orange
        });
      } else {
        tempNotifs.add({
          "title": "Kerja Bagus!",
          "body": "Semua pekerjaan telah selesai.",
          "icon": Icons.check_circle,
          "color": Colors.blue
        });
      }

    } else if (widget.role == 'Pelanggan') {
      // Cek Status Mobil
      final trx = await DatabaseHelper().getTransactionsByCustomer(widget.username);
      if (trx.isNotEmpty) {
        final latest = trx.first;
        tempNotifs.add({
          "title": "Update Status Mobil",
          "body": "Mobil Anda saat ini statusnya: ${latest.status}",
          "icon": Icons.car_repair,
          "color": latest.status == 'Selesai' ? Colors.green : Colors.orange
        });
      } else {
        tempNotifs.add({
          "title": "Selamat Datang",
          "body": "Belum ada riwayat servis. Yuk servis mobilmu!",
          "icon": Icons.waving_hand,
          "color": Colors.blue
        });
      }
    }

    setState(() {
      _notifications = tempNotifs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notifikasi")),
      body: _notifications.isEmpty
          ? const Center(child: Text("Tidak ada notifikasi baru."))
          : ListView.builder(
        itemCount: _notifications.length,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final item = _notifications[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: item['color'].withOpacity(0.2),
                child: Icon(item['icon'], color: item['color']),
              ),
              title: Text(item['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(item['body']),
            ),
          );
        },
      ),
    );
  }
}