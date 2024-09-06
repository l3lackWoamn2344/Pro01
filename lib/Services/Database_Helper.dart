import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'user_database.db');

    return await openDatabase(
      path,
      version: 2, // Increment version for schema updates
      onCreate: _onCreate,
      onUpgrade: _onUpgrade, // Handle upgrading schema
    );
  }

  // Create tables
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        UserName TEXT, 
        Password TEXT, 
        Email TEXT)
    ''');

    await db.execute('''
      CREATE TABLE children (
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        firstName TEXT, 
        lastName TEXT, 
        nickname TEXT, 
        birthdate TEXT, 
        height REAL, 
        weight REAL, 
        bloodType TEXT, 
        allergies TEXT, 
        gender TEXT, 
        createDate DATETIME, 
        modifyDate DATETIME)
    ''');

    await db.execute('''
      CREATE TABLE VACCINE (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        vaccineType TEXT NOT NULL, 
        time TEXT NOT NULL,
        date TEXT NOT NULL)
    ''');
  }

  // Handle database upgrades
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      // Example upgrade: modify schema or add new tables/columns
      // Add a new table or columns if necessary
      // await db.execute('ALTER TABLE children ADD COLUMN newColumn TEXT');
    }
  }

  // Vaccine CRUD operations
  Future<void> insertVaccine(Map<String, dynamic> vaccine) async {
    try {
      final db = await database;
      await db.insert('VACCINE', vaccine);
    } catch (e) {
      print('Error inserting vaccine: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getVaccines() async {
    try {
      final db = await database;
      return await db.query('VACCINE');
    } catch (e) {
      print('Error retrieving vaccines: $e');
      return [];
    }
  }

  Future<void> deleteVaccine(int id) async {
    try {
      final db = await database;
      await db.delete('VACCINE', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      print('Error deleting vaccine: $e');
    }
  }

  Future<void> updateVaccine(Map<String, dynamic> vaccine) async {
    try {
      final db = await database;
      await db.update('VACCINE', vaccine, where: 'id = ?', whereArgs: [vaccine['id']]);
    } catch (e) {
      print('Error updating vaccine: $e');
    }
  }

  // Batch insert for vaccine
  Future<void> batchInsertVaccines(List<Map<String, dynamic>> vaccines) async {
    final db = await database;
    Batch batch = db.batch();

    for (var vaccine in vaccines) {
      batch.insert('VACCINE', vaccine);
    }
    await batch.commit(noResult: true);
  }

  // User operations
  Future<int> insertUser(Map<String, dynamic> user) async {
    try {
      final db = await database;
      return await db.insert('users', user);
    } catch (e) {
      print('Error inserting user: $e');
      return -1; // Return an error code
    }
  }

  Future<Map<String, dynamic>?> getUser(String username) async {
    try {
      final db = await database;
      final result = await db.query('users', where: 'UserName = ?', whereArgs: [username]);
      if (result.isNotEmpty) {
        return result.first;
      }
      return null;
    } catch (e) {
      print('Error retrieving user: $e');
      return null;
    }
  }

  // Child CRUD operations
  Future<int> insertChild(Map<String, dynamic> child) async {
    try {
      final db = await database;
      return await db.insert('children', child);
    } catch (e) {
      print('Error inserting child: $e');
      return -1; // Return an error code
    }
  }

  Future<List<Map<String, dynamic>>> getAllChildren() async {
    try {
      final db = await database;
      return await db.query('children');
    } catch (e) {
      print('Error retrieving children: $e');
      return [];
    }
  }

  Future<void> deleteChild(int id) async {
    try {
      final db = await database;
      await db.delete('children', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      print('Error deleting child: $e');
    }
  }

  Future<void> updateChild(Map<String, dynamic> child) async {
    try {
      final db = await database;
      await db.update('children', child, where: 'id = ?', whereArgs: [child['id']]);
    } catch (e) {
      print('Error updating child: $e');
    }
  }
}
