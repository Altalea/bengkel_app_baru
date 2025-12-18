import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'shop_model.dart';
import 'employee_model.dart';
import 'package_model.dart';
import 'customer_model.dart';
import 'supplier_model.dart';

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
    // GANTI VERSI DB BIAR TABEL BARU KEFRESH
    String path = join(await getDatabasesPath(), 'bengkel_v3.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // 1. Shops
    await db.execute('''
      CREATE TABLE shops(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        shopName TEXT, address TEXT, ownerName TEXT, type TEXT, imagePath TEXT
      )
    ''');
    // 2. Employees
    await db.execute('''
      CREATE TABLE employees(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT, position TEXT, phone TEXT, imagePath TEXT
      )
    ''');
    // 3. Packages
    await db.execute('''
      CREATE TABLE packages(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT, price REAL, type TEXT, description TEXT
      )
    ''');
    // 4. Customers (UPDATE LEBIH LENGKAP)
    await db.execute('''
      CREATE TABLE customers(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT, phone TEXT, email TEXT, address TEXT, vehicleNumber TEXT
      )
    ''');
    // 5. Suppliers (UPDATE LEBIH LENGKAP)
    await db.execute('''
      CREATE TABLE suppliers(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT, phone TEXT, email TEXT, address TEXT, category TEXT
      )
    ''');
  }

  // --- CRUD METHODS (Tidak Berubah, Copy Paste saja biar aman) ---

  Future<int> insertShop(Shop shop) async {
    final db = await database; return await db.insert('shops', shop.toMap());
  }
  Future<List<Shop>> getShops() async {
    final db = await database; final maps = await db.query('shops');
    return List.generate(maps.length, (i) => Shop.fromMap(maps[i]));
  }

  Future<int> insertEmployee(Employee employee) async {
    final db = await database; return await db.insert('employees', employee.toMap());
  }
  Future<List<Employee>> getEmployees() async {
    final db = await database; final maps = await db.query('employees');
    return List.generate(maps.length, (i) => Employee.fromMap(maps[i]));
  }

  Future<int> insertPackage(Package package) async {
    final db = await database; return await db.insert('packages', package.toMap());
  }
  Future<List<Package>> getPackages() async {
    final db = await database; final maps = await db.query('packages');
    return List.generate(maps.length, (i) => Package.fromMap(maps[i]));
  }

  Future<int> insertCustomer(Customer customer) async {
    final db = await database; return await db.insert('customers', customer.toMap());
  }
  Future<List<Customer>> getCustomers() async {
    final db = await database; final maps = await db.query('customers');
    return List.generate(maps.length, (i) => Customer.fromMap(maps[i]));
  }

  Future<int> insertSupplier(Supplier supplier) async {
    final db = await database; return await db.insert('suppliers', supplier.toMap());
  }
  Future<List<Supplier>> getSuppliers() async {
    final db = await database; final maps = await db.query('suppliers');
    return List.generate(maps.length, (i) => Supplier.fromMap(maps[i]));
  }
}