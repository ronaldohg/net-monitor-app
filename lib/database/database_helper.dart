import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/radiobase3g.dart';
import '../models/radiobase4g.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'radiobases.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE radiobases3g(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        psc TEXT NOT NULL UNIQUE
      )
    ''');
    
    await db.execute('''
      CREATE TABLE radiobases4g(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        ci TEXT NOT NULL UNIQUE
      )
    ''');
  }

  // Métodos para RadioBase3G
  Future<int> insert3G(RadioBase3G rb) async {
    Database db = await database;
    return await db.insert('radiobases3g', rb.toMap(), 
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<List<RadioBase3G>> getAll3G() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('radiobases3g');
    return List.generate(maps.length, (i) {
      return RadioBase3G.fromMap(maps[i]);
    });
  }

  Future<int> delete3G(int id) async {
    Database db = await database;
    return await db.delete('radiobases3g', where: 'id = ?', whereArgs: [id]);
  }

  Future<RadioBase3G?> get3GByPSC(String psc) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'radiobases3g',
      where: 'psc = ?',
      whereArgs: [psc],
    );
    if (maps.isNotEmpty) {
      return RadioBase3G.fromMap(maps.first);
    }
    return null;
  }

  // Métodos para RadioBase4G
  Future<int> insert4G(RadioBase4G rb) async {
    Database db = await database;
    return await db.insert('radiobases4g', rb.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<List<RadioBase4G>> getAll4G() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('radiobases4g');
    return List.generate(maps.length, (i) {
      return RadioBase4G.fromMap(maps[i]);
    });
  }

  Future<int> delete4G(int id) async {
    Database db = await database;
    return await db.delete('radiobases4g', where: 'id = ?', whereArgs: [id]);
  }

  Future<RadioBase4G?> get4GByCI(String ci) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'radiobases4g',
      where: 'ci = ?',
      whereArgs: [ci],
    );
    if (maps.isNotEmpty) {
      return RadioBase4G.fromMap(maps.first);
    }
    return null;
  }
}