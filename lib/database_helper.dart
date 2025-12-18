import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// Import semua Model yang sudah kita buat
import 'shop_model.dart';
import 'employee_model.dart';
import 'package_model.dart'; // Pastikan file package_model.dart sudah dibuat

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
    String path = join(await getDatabasesPath(), 'bengkel_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // --- MEMBUAT TABEL DI SINI ---
  Future<void> _onCreate(Database db, int version) async {
    // 1. Tabel Shops (Bengkel)
    await db.execute('''
      CREATE TABLE shops(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        shopName TEXT,
        address TEXT,
        ownerName TEXT,
        type TEXT,
        imagePath TEXT
      )
    ''');

    // 2. Tabel Employees (Pegawai)
    await db.execute('''
      CREATE TABLE employees(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        position TEXT,
        phone TEXT,
        imagePath TEXT
      )
    ''');

    // 3. Tabel Packages (Jasa & Sparepart)
    await db.execute('''
      CREATE TABLE packages(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        price REAL,
        type TEXT,
        description TEXT
      )
    ''');
  }

  // ===============================================================
  // BAGIAN 1: FUNGSI UNTUK SHOP (BENGKEL)
  // ===============================================================
  Future<int> insertShop(Shop shop) async {
    final db = await database;
    return await db.insert('shops', shop.toMap());
  }

  Future<List<Shop>> getShops() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('shops');
    return List.generate(maps.length, (i) {
      return Shop.fromMap(maps[i]);
    });
  }

  // ===============================================================
  // BAGIAN 2: FUNGSI UNTUK EMPLOYEE (PEGAWAI)
  // ===============================================================
  Future<int> insertEmployee(Employee employee) async {
    final db = await database;
    return await db.insert('employees', employee.toMap());
  }

  Future<List<Employee>> getEmployees() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('employees');
    return List.generate(maps.length, (i) {
      return Employee.fromMap(maps[i]);
    });
  }

  // ===============================================================
  // BAGIAN 3: FUNGSI UNTUK PACKAGES (JASA & SPAREPART)
  // ===============================================================
  Future<int> insertPackage(Package package) async {
    final db = await database;
    return await db.insert('packages', package.toMap());
  }

  Future<List<Package>> getPackages() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('packages');
    return List.generate(maps.length, (i) {
      return Package.fromMap(maps[i]);
    });
  }

  Future<void> deletePackage(int id) async {
    final db = await database;
    await db.delete('packages', where: 'id = ?', whereArgs: [id]);
  }
}