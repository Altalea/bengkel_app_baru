import 'package:flutter/material.dart';
import '../database_helper.dart';
import '../package_model.dart';
import 'add_package_screen.dart';

class ManagePackageScreen extends StatefulWidget {
  const ManagePackageScreen({super.key});

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

  Future<void> _navigateToAdd() async {
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => const AddPackageScreen()));
    if (result == true) _refreshList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("My Package", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
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
                label: const Text("Add Package", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.purple, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _packageList.isEmpty
                  ? const Center(child: Text("Belum ada paket servis."))
                  : ListView.builder(
                itemCount: _packageList.length,
                itemBuilder: (context, index) {
                  final p = _packageList[index];
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.purple.shade100,
                        child: const Icon(Icons.card_giftcard, color: Colors.purple, size: 20),
                      ),
                      title: Text(p.packageName, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(p.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                      trailing: Text(
                        p.price,
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 16),
                      ),
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