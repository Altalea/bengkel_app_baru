import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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
    // NAIK KE VERSI 5
    String path = join(await getDatabasesPath(), 'bengkel_v5.db');
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

    // TABEL TRANSAKSI (UPDATE: ADA STATUS)
    await db.execute('CREATE TABLE transactions(id INTEGER PRIMARY KEY AUTOINCREMENT, customerName TEXT, mechanicName TEXT, date TEXT, items TEXT, totalPrice REAL, status TEXT)');
  }

  // --- CRUD METHODS ---
  // (Bagian Shop, Employee, dll sama persis. Copy paste saja yang Transaction & Update Status di bawah ini)

  Future<int> insertShop(Shop shop) async { final db = await database; return await db.insert('shops', shop.toMap()); }
  Future<List<Shop>> getShops() async { final db = await database; final maps = await db.query('shops'); return List.generate(maps.length, (i) => Shop.fromMap(maps[i])); }

  Future<int> insertEmployee(Employee employee) async { final db = await database; return await db.insert('employees', employee.toMap()); }
  Future<List<Employee>> getEmployees() async { final db = await database; final maps = await db.query('employees'); return List.generate(maps.length, (i) => Employee.fromMap(maps[i])); }

  Future<int> insertPackage(Package package) async { final db = await database; return await db.insert('packages', package.toMap()); }
  Future<List<Package>> getPackages() async { final db = await database; final maps = await db.query('packages'); return List.generate(maps.length, (i) => Package.fromMap(maps[i])); }
  Future<void> deletePackage(int id) async { final db = await database; await db.delete('packages', where: 'id = ?', whereArgs: [id]); }

  Future<int> insertCustomer(Customer customer) async { final db = await database; return await db.insert('customers', customer.toMap()); }
  Future<List<Customer>> getCustomers() async { final db = await database; final maps = await db.query('customers'); return List.generate(maps.length, (i) => Customer.fromMap(maps[i])); }

  Future<int> insertSupplier(Supplier supplier) async { final db = await database; return await db.insert('suppliers', supplier.toMap()); }
  Future<List<Supplier>> getSuppliers() async { final db = await database; final maps = await db.query('suppliers'); return List.generate(maps.length, (i) => Supplier.fromMap(maps[i])); }

  // --- TRANSAKSI ---
  Future<int> insertTransaction(TransactionModel transaction) async {
    final db = await database;
    return await db.insert('transactions', transaction.toMap());
  }

  // UPDATE STATUS TRANSAKSI
  Future<void> updateTransactionStatus(int id, String newStatus) async {
    final db = await database;
    await db.update(
      'transactions',
      {'status': newStatus},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<TransactionModel>> getTransactions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('transactions', orderBy: "id DESC");
    return List.generate(maps.length, (i) => TransactionModel.fromMap(maps[i]));
  }

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