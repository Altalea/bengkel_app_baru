import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Pastikan tambah intl di pubspec.yaml jika belum
import '../database_helper.dart';
import 'login_page.dart';

class CustomerDashboard extends StatefulWidget {
  final String username;
  const CustomerDashboard({super.key, required this.username});

  @override
  State<CustomerDashboard> createState() => _CustomerDashboardState();
}

class _CustomerDashboardState extends State<CustomerDashboard> {
  int _selectedIndex = 0; // 0: Katalog, 1: Keranjang, 2: Profil

  // Data Keranjang
  List<Map<String, dynamic>> _cart = [];

  // Form Booking
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _selectedMechanic;
  List<String> _mechanicList = [];

  // Data Katalog
  List<Map<String, dynamic>> _catalog = [];

  @override
  void initState() {
    super.initState();
    _loadCatalog();
    _loadMechanics();
  }

  void _loadCatalog() async {
    final data = await DatabaseHelper().getPackages();
    setState(() {
      _catalog = data.map((e) => e.toMap()).toList();
    });
  }

  void _loadMechanics() async {
    final data = await DatabaseHelper().getEmployees();
    setState(() {
      _mechanicList = data
          .where((e) => e.position == 'Mekanik')
          .map((e) => e.name)
          .toList();
    });
  }

  // --- LOGIKA KERANJANG ---
  void _addToCart(Map<String, dynamic> item) {
    setState(() {
      _cart.add(item);
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("${item['name']} masuk keranjang!"),
      duration: const Duration(milliseconds: 500),
    ));
  }

  void _removeFromCart(int index) {
    setState(() {
      _cart.removeAt(index);
    });
  }

  double _getTotalPrice() {
    return _cart.fold(0, (sum, item) => sum + (item['price'] as double));
  }

  // --- PROSES CHECKOUT (BOOKING) ---
  void _checkout() async {
    if (_cart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Keranjang kosong!")));
      return;
    }
    if (_selectedDate == null || _selectedTime == null || _selectedMechanic == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Lengkapi Tanggal, Jam, dan Mekanik!")));
      return;
    }

    // Format Tanggal & Jam
    String dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate!);
    String timeStr = _selectedTime!.format(context);
    String fullDate = "$dateStr $timeStr";

    // Gabung item jadi string
    String itemsStr = _cart.map((e) => e['name']).join(", ");

    // Simpan ke Database (Status: Pending)
    Map<String, dynamic> trx = {
      'customerName': widget.username,
      'mechanicName': _selectedMechanic,
      'date': fullDate,
      'items': itemsStr,
      'totalPrice': _getTotalPrice(),
      'status': 'Pending'
    };

    final db = await DatabaseHelper().database;
    await db.insert('transactions', trx);

    // Reset
    setState(() {
      _cart.clear();
      _selectedDate = null;
      _selectedTime = null;
      _selectedMechanic = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Booking Berhasil! Menunggu Konfirmasi Bengkel."),
      backgroundColor: Colors.green,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildCatalogPage(),
      _buildCartPage(),
      _buildProfilePage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Layanan Pelanggan"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => const LoginPage()));
            },
          )
        ],
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (idx) => setState(() => _selectedIndex = idx),
        selectedItemColor: Colors.orange,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.store), label: "Katalog"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Keranjang"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil Kendaraan"),
        ],
      ),
    );
  }

  // --- HALAMAN 1: KATALOG ---
  Widget _buildCatalogPage() {
    if (_catalog.isEmpty) return const Center(child: Text("Belum ada layanan tersedia."));

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: _catalog.length,
      itemBuilder: (context, index) {
        final item = _catalog[index];
        return Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  ),
                  child: const Icon(Icons.car_repair, size: 50, color: Colors.orange),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                    Text("Rp ${item['price']}", style: const TextStyle(color: Colors.green)),
                    const SizedBox(height: 5),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white),
                        onPressed: () => _addToCart(item),
                        child: const Text("Tambah"),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  // --- HALAMAN 2: KERANJANG & BOOKING ---
  Widget _buildCartPage() {
    return Column(
      children: [
        Expanded(
          child: _cart.isEmpty
              ? const Center(child: Text("Keranjang Kosong"))
              : ListView.builder(
            itemCount: _cart.length,
            itemBuilder: (context, index) {
              final item = _cart[index];
              return ListTile(
                leading: const Icon(Icons.check_circle, color: Colors.green),
                title: Text(item['name']),
                subtitle: Text("Rp ${item['price']}"),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _removeFromCart(index),
                ),
              );
            },
          ),
        ),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [BoxShadow(blurRadius: 5, color: Colors.grey.withOpacity(0.2))]
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Detail Booking", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 10),

              DropdownButtonFormField<String>(
                value: _selectedMechanic,
                hint: const Text("Pilih Mekanik"),
                items: _mechanicList.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                onChanged: (val) => setState(() => _selectedMechanic = val),
              ),

              Row(
                children: [
                  Expanded(
                    child: TextButton.icon(
                      icon: const Icon(Icons.calendar_today),
                      label: Text(_selectedDate == null ? "Pilih Tanggal" : DateFormat('dd MMM').format(_selectedDate!)),
                      onPressed: () async {
                        final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2026)
                        );
                        if(date != null) setState(() => _selectedDate = date);
                      },
                    ),
                  ),
                  Expanded(
                    child: TextButton.icon(
                      icon: const Icon(Icons.access_time),
                      label: Text(_selectedTime == null ? "Pilih Jam" : _selectedTime!.format(context)),
                      onPressed: () async {
                        final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                        if(time != null) setState(() => _selectedTime = time);
                      },
                    ),
                  ),
                ],
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Total:", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("Rp ${_getTotalPrice()}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.orange)),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _checkout,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.symmetric(vertical: 12)),
                  child: const Text("BOOKING SEKARANG", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  // --- HALAMAN 3: PROFIL KENDARAAN ---
  Widget _buildProfilePage() {
    final vehicleNumCtrl = TextEditingController();
    final vehicleModelCtrl = TextEditingController();

    return FutureBuilder<Map<String, dynamic>?>(
        future: DatabaseHelper().getCustomerDetail(widget.username),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          var data = snapshot.data!;
          vehicleNumCtrl.text = data['vehicleNumber'] ?? '';
          vehicleModelCtrl.text = data['vehicleModel'] ?? '';

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
                const SizedBox(height: 10),
                Text(widget.username, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 30),

                const Align(alignment: Alignment.centerLeft, child: Text("Detail Kendaraan", style: TextStyle(color: Colors.grey))),
                const SizedBox(height: 10),
                TextField(
                  controller: vehicleModelCtrl,
                  decoration: const InputDecoration(labelText: "Merk & Model (Cth: Honda Jazz 2020)", prefixIcon: Icon(Icons.car_rental), border: OutlineInputBorder()),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: vehicleNumCtrl,
                  decoration: const InputDecoration(labelText: "Nomor Polisi (Cth: B 1234 CD)", prefixIcon: Icon(Icons.confirmation_number), border: OutlineInputBorder()),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await DatabaseHelper().updateVehicleProfile(widget.username, vehicleNumCtrl.text, vehicleModelCtrl.text);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Profil Kendaraan Disimpan!")));
                  },
                  child: const Text("Simpan Data Kendaraan"),
                )
              ],
            ),
          );
        }
    );
  }
}