import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// Import semua model
import 'shop_model.dart';
import 'employee_model.dart';
import 'package_model.dart';
import 'customer_model.dart';
import 'supplier_model.dart';
import 'transaction_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Gunakan V6 agar struktur tabel password terbentuk
    String path = join(await getDatabasesPath(), 'bengkel_v6.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // 1. Shop
    await db.execute('CREATE TABLE shops(id INTEGER PRIMARY KEY AUTOINCREMENT, shopName TEXT, address TEXT, ownerName TEXT, type TEXT, imagePath TEXT)');

    // 2. Employees (Ada Password)
    await db.execute('CREATE TABLE employees(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, position TEXT, phone TEXT, imagePath TEXT, password TEXT)');

    // 3. Packages
    await db.execute('CREATE TABLE packages(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, price REAL, type TEXT, description TEXT)');

    // 4. Customers (Ada Password)
    await db.execute('CREATE TABLE customers(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, phone TEXT, email TEXT, address TEXT, vehicleNumber TEXT, password TEXT)');

    // 5. Suppliers
    await db.execute('CREATE TABLE suppliers(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, phone TEXT, email TEXT, address TEXT, category TEXT)');

    // 6. Transactions
    await db.execute('CREATE TABLE transactions(id INTEGER PRIMARY KEY AUTOINCREMENT, customerName TEXT, mechanicName TEXT, date TEXT, items TEXT, totalPrice REAL, status TEXT)');

    // --- BUAT AKUN OWNER DEFAULT (ADMIN) ---
    // Username: Admin, Password: admin
    await db.insert('employees', {
      'name': 'Admin',
      'position': 'Owner',
      'phone': '08123456789',
      'imagePath': '',
      'password': 'admin',
    });
  }

  // --- LOGIN SYSTEM ---
  Future<Map<String, dynamic>?> loginUser(String name, String password, String role) async {
    final db = await database;

    if (role == 'Pelanggan') {
      final res = await db.query('customers',
          where: 'name = ? AND password = ?',
          whereArgs: [name, password]
      );
      if (res.isNotEmpty) return res.first;
    } else {
      // Owner atau Mekanik (Cek tabel employees)
      final res = await db.query('employees',
          where: 'name = ? AND password = ? AND position = ?',
          whereArgs: [name, password, role]
      );
      if (res.isNotEmpty) return res.first;
    }
    return null;
  }

  // --- GANTI PASSWORD ---
  Future<int> changePassword(String name, String role, String newPassword) async {
    final db = await database;

    if (role == 'Pelanggan') {
      return await db.update(
        'customers',
        {'password': newPassword},
        where: 'name = ?',
        whereArgs: [name],
      );
    } else {
      return await db.update(
        'employees',
        {'password': newPassword},
        where: 'name = ? AND position = ?',
        whereArgs: [name, role],
      );
    }
  }

  // --- CRUD METHODS ---

  // Shop
  Future<int> insertShop(Shop shop