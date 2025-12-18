import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'shop_model.dart';
import 'employee_model.dart';
import 'package_model.dart';
import 'customer_model.dart';
import 'supplier_model.dart';
import 'transaction_model.dart'; // Import model baru

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
    // GANTI KE V4 AGAR TABEL BARU TERBENTUK
    String path = join(await getDatabasesPath(), 'bengkel_v4.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('CREATE TABLE shops(id INTEGER PRIMARY KEY AUTOINCREMENT, shopName TEXT, address TEXT, ownerName TEXT, type TEXT, imagePath TEXT)');
    await db.execute('CREATE TABLE employees(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, position TEXT, phone TEXT, imagePath TEXT)');
    await db.execute('CREATE TABLE packages(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, price REAL, type TEXT, description TEXT)');
    await db.execute('CREATE TABLE customers(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, phone TEXT, email TEXT, address TEXT, vehicleNumber TEXT)');
    await db.execute('CREATE TABLE suppliers(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, phone TEXT, email TEXT, address TEXT, category TEXT)');

    // TABEL TRANSAKSI (BARU)
    await db.execute('CREATE TABLE transactions(id INTEGER PRIMARY KEY AUTOINCREMENT, customerName TEXT, mechanicName TEXT, date TEXT, items TEXT, totalPrice REAL)');
  }

  // --- CRUD METHODS ---
  // (Method lain dianggap sama, copy saja yang Transaction di bawah ini)

  // Shop, Employee, Package, Customer, Supplier code... (Gunakan kode sebelumnya untuk bagian ini jika ingin lengkap, atau biarkan auto-complete IDE jika sudah ada)
  // SUPAYA KODENYA GAK KEPANJANGAN, SAYA TULIS BAGIAN PENTING SAJA:

  Future<int> insertShop(Shop shop) async { final db = await database; return await db.insert('shops', shop.toMap()); }
  Future<List<Shop>> getShops() async { final db = await database; final maps = await db.query('shops'); return List.generate(maps.length, (i) => Shop.fromMap(maps[i])); }

  Future<int> insertEmployee(Employee employee) async { final db = await database; return await db.insert('employees', employee.toMap()); }
  Future<List<Employee>> getEmployees() async { final db = await database; final maps = await db.query('employees'); return List.generate(maps.length, (i) => Employee.fromMap(maps[i])); }

  Future<int> insertPackage(Package package) async { final db = await database; return await db.insert('packages', package.toMap()); }
  Future<List<Package>> getPackages() async { final db = await database; final maps = await db.query('packages'); return List.generate(maps.length, (i) => Package.fromMap(maps[i])); }
  Future<void> deletePackage(int id) async { final db = await database; await db.delete('packages', where: 'id = ?', whereArgs: [id]); } // Tambahan delete

  Future<int> insertCustomer(Customer customer) async { final db = await database; return await db.insert('customers', customer.toMap()); }
  Future<List<Customer>> getCustomers() async { final db = await database; final maps = await db.query('customers'); return List.generate(maps.length, (i) => Customer.fromMap(maps[i])); }

  Future<int> insertSupplier(Supplier supplier) async { final db = await database; return await db.insert('suppliers', supplier.toMap()); }
  Future<List<Supplier>> getSuppliers() async { final db = await database; final maps = await db.query('suppliers'); return List.generate(maps.length, (i) => Supplier.fromMap(maps[i])); }

  // --- TRANSAKSI (BARU) ---
  Future<int> insertTransaction(TransactionModel transaction) async {
    final db = await database;
    return await db.insert('transactions', transaction.toMap());
  }

  Future<List<TransactionModel>> getTransactions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('transactions', orderBy: "id DESC");
    return List.generate(maps.length, (i) => TransactionModel.fromMap(maps[i]));
  }

  // Filter khusus Pelanggan (Lihat riwayat sendiri)
  Future<List<TransactionModel>> getTransactionsByCustomer(String name) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
        'transactions',
        where: 'customerName = ?',
        whereArgs: [name],
        orderBy: "id DESC"
    );
    return List.generate(maps.length, (i) => TransactionModel.fromMap(maps[i]));
  }
}