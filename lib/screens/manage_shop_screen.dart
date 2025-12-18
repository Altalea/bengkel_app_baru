import 'package:flutter/material.dart';
import 'dart:io';                 // TAMBAHAN: Import ini wajib untuk menampilkan File Foto
import '../database_helper.dart'; // Import Database
import '../shop_model.dart';      // Import Model Data
import 'add_shop_screen.dart';    // Import Halaman Add

class ManageShopScreen extends StatefulWidget {
  const ManageShopScreen({super.key});

  @override
  State<ManageShopScreen> createState() => _ManageShopScreenState();
}

class _ManageShopScreenState extends State<ManageShopScreen> {
  // Variabel penampung data bengkel
  List<Shop> _shopList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _refreshShopList(); // Ambil data saat halaman pertama kali dibuka
  }

  // Fungsi untuk mengambil data dari Database
  Future<void> _refreshShopList() async {
    final data = await DatabaseHelper().getShops();
    setState(() {
      _shopList = data;
      _isLoading = false;
    });
    // print("Jumlah bengkel di database: ${_shopList.length}");
  }

  // Fungsi pindah ke halaman Add Shop dan Refresh saat kembali
  Future<void> _navigateToAddShop() async {
    // Tunggu hasil (await) dari halaman Add Shop
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddShopScreen()),
    );

    // Jika result == true (artinya berhasil simpan), refresh data
    if (result == true) {
      _refreshShopList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          "Manage Shop",
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Tombol ADD SHOP ---
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _navigateToAddShop,
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  "Add Shop",
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // --- Label Total Toko ---
            Text(
              "Total shop: ${_shopList.length.toString().padLeft(2, '0')}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),

            const SizedBox(height: 10),

            // --- Daftar Bengkel ---
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _shopList.isEmpty
                  ? const Center(child: Text("Belum ada bengkel. Tambahkan sekarang!"))
                  : ListView.builder(
                itemCount: _shopList.length,
                itemBuilder: (context, index) {
                  final shop = _shopList[index];
                  return _buildShopCard(shop);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Widget Kartu Bengkel ---
  Widget _buildShopCard(Shop shop) {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          // Header Label Tipe
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.orange.shade100,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  shop.type,
                  style: TextStyle(
                    color: Colors.deepOrange.shade800,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                Row(
                  children: const [
                    Icon(Icons.edit, size: 18, color: Colors.grey),
                    SizedBox(width: 12),
                    Icon(Icons.delete, size: 18, color: Colors.grey),
                  ],
                )
              ],
            ),
          ),

          // Isi Kartu
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // --- BAGIAN LOGO / FOTO BENGKEL (DIPERBAIKI) ---
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  // LOGIKA: Jika path gambar ada & file-nya ada di HP, tampilkan gambar.
                  // Jika tidak, tampilkan Icon Toko.
                  child: (shop.imagePath != null && shop.imagePath!.isNotEmpty && File(shop.imagePath!).existsSync())
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Image.file(
                      File(shop.imagePath!),
                      fit: BoxFit.cover,
                      width: 50,
                      height: 50,
                    ),
                  )
                      : const Icon(Icons.store, size: 28, color: Colors.deepOrange),
                ),
                // -----------------------------------------------

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        shop.shopName,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Shop ID: ${shop.id}",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        shop.address,
                        style: const TextStyle(fontSize: 13, color: Colors.black54),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Owner Name\n${shop.ownerName}",
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}