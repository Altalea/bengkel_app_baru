import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Import semua model
import 'shop_model.dart';
import 'employee_model.dart';
import 'package_model.dart';
import 'customer_model.dart';
import 'supplier_model.dart';
import 'transaction_model.dart';

class DatabaseHelper {
  // Ganti IP ini sesuai server Laravel Anda.
  // Jika pakai Emulator Android: 'http://10.0.2.2:8000/api'
  // Jika pakai HP fisik (satu wifi): 'http://192.168.x.x:8000/api'
  // Jika sudah online: 'https://domain-anda.com/api'
  static const String baseUrl = 'http://172.20.10.3:8000/api';

  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  // --- HELPER: Mengambil Header (Termasuk Token) ---
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token'); // Ambil token yang disimpan saat login
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // --- AUTH: LOGIN ---
  Future<Map<String, dynamic>?> loginUser(String username, String password, String role) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: jsonEncode({
          'name': username, // Sesuaikan dengan field di Laravel (email/name)
          'password': password,
          'role': role,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Simpan Token ke HP
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);

        return data['user']; // Mengembalikan data user
      }
    } catch (e) {
      print("Error Login: $e");
    }
    return null;
  }

  // --- AUTH: LOGOUT (Opsional) ---
  Future<void> logout() async {
    final headers = await _getHeaders();
    await http.post(Uri.parse('$baseUrl/logout'), headers: headers);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  // --- CRUD: SHOPS ---
  Future<List<Shop>> getShops() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/shops'), headers: await _getHeaders());
      if (response.statusCode == 200) {
        // Laravel biasanya return: { "data": [...] }
        final List data = jsonDecode(response.body)['data'];
        return data.map((e) => Shop.fromMap(e)).toList();
      }
    } catch (e) {
      print("Error getShops: $e");
    }
    return [];
  }

  Future<bool> insertShop(Shop shop) async {
    final response = await http.post(
      Uri.parse('$baseUrl/shops'),
      headers: await _getHeaders(),
      body: jsonEncode(shop.toMap()),
    );
    return response.statusCode == 201 || response.statusCode == 200;
  }

  // --- CRUD: EMPLOYEES ---
  Future<List<Employee>> getEmployees() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/employees'), headers: await _getHeaders());
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body)['data'];
        return data.map((e) => Employee.fromMap(e)).toList();
      }
    } catch (e) {
      print("Error getEmployees: $e");
    }
    return [];
  }

  Future<bool> insertEmployee(Employee employee) async {
    final response = await http.post(
      Uri.parse('$baseUrl/employees'),
      headers: await _getHeaders(),
      body: jsonEncode(employee.toMap()),
    );
    return response.statusCode == 201;
  }

  // --- CRUD: PACKAGES / SERVICES ---
  Future<List<Package>> getPackages() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/services'), headers: await _getHeaders());
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body)['data'];
        return data.map((e) => Package.fromMap(e)).toList();
      }
    } catch (e) {
      print("Error getPackages: $e");
    }
    return [];
  }

  Future<bool> insertPackage(Package package) async {
    final response = await http.post(
      Uri.parse('$baseUrl/services'),
      headers: await _getHeaders(),
      body: jsonEncode(package.toMap()),
    );
    return response.statusCode == 201;
  }

  Future<bool> deletePackage(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/services/$id'),
      headers: await _getHeaders(),
    );
    return response.statusCode == 200;
  }

  // --- CRUD: CUSTOMERS ---
  Future<List<Customer>> getCustomers() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/customers'), headers: await _getHeaders());
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body)['data'];
        return data.map((e) => Customer.fromMap(e)).toList();
      }
    } catch (e) {
      print("Error getCustomers: $e");
    }
    return [];
  }

  Future<bool> insertCustomer(Customer customer) async {
    // Register customer baru (Endpoint public/register di Laravel)
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(customer.toMap()),
    );
    return response.statusCode == 201;
  }

  Future<Map<String, dynamic>?> getCustomerDetail(String name) async {
    // Di API, biasanya get profile berdasarkan Token, bukan nama parameter
    final response = await http.get(Uri.parse('$baseUrl/user'), headers: await _getHeaders());
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return null;
  }

  Future<bool> updateVehicleProfile(String name, String number, String model) async {
    final response = await http.put(
      Uri.parse('$baseUrl/profile/vehicle'), // Endpoint khusus update kendaraan
      headers: await _getHeaders(),
      body: jsonEncode({
        'vehicleNumber': number,
        'vehicleModel': model
      }),
    );
    return response.statusCode == 200;
  }

  // --- CRUD: SUPPLIERS ---
  Future<List<Supplier>> getSuppliers() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/suppliers'), headers: await _getHeaders());
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body)['data'];
        return data.map((e) => Supplier.fromMap(e)).toList();
      }
    } catch (e) {
      print("Error getSuppliers: $e");
    }
    return [];
  }

  Future<bool> insertSupplier(Supplier supplier) async {
    final response = await http.post(
      Uri.parse('$baseUrl/suppliers'),
      headers: await _getHeaders(),
      body: jsonEncode(supplier.toMap()),
    );
    return response.statusCode == 201;
  }

  // --- CRUD: TRANSACTIONS ---
  Future<List<TransactionModel>> getTransactions() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/transactions'), headers: await _getHeaders());
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body)['data'];
        return data.map((e) => TransactionModel.fromMap(e)).toList();
      }
    } catch (e) {
      print("Error getTransactions: $e");
    }
    return [];
  }

  // Untuk Customer melihat history sendiri (Logic filter biasanya di Backend)
  Future<List<TransactionModel>> getTransactionsByCustomer(String name) async {
    // Endpoint sama, Backend yang filter berdasarkan Token user yang login
    return await getTransactions();
  }

  Future<bool> insertTransaction(TransactionModel transaction) async {
    final response = await http.post(
      Uri.parse('$baseUrl/transactions'),
      headers: await _getHeaders(),
      body: jsonEncode(transaction.toMap()),
    );
    return response.statusCode == 201;
  }

  Future<bool> updateTransactionStatus(int id, String newStatus) async {
    final response = await http.put(
      Uri.parse('$baseUrl/transactions/$id/status'),
      headers: await _getHeaders(),
      body: jsonEncode({'status': newStatus}),
    );
    return response.statusCode == 200;
  }

  // --- SETTINGS: GANTI PASS / USERNAME ---
  Future<bool> changePassword(String name, String role, String newPassword) async {
    final response = await http.put(
      Uri.parse('$baseUrl/profile/password'),
      headers: await _getHeaders(),
      body: jsonEncode({'password': newPassword}),
    );
    return response.statusCode == 200;
  }

  Future<bool> updateUsername(String oldName, String newName, String role) async {
    final response = await http.put(
      Uri.parse('$baseUrl/profile/name'),
      headers: await _getHeaders(),
      body: jsonEncode({'name': newName}),
    );
    return response.statusCode == 200;
  }
}