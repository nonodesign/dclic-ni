import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../modele/redacteur.dart';

class DatabaseManager {
  static final DatabaseManager _instance = DatabaseManager._internal();
  factory DatabaseManager() => _instance;
  DatabaseManager._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'redacteurs.db');

    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE redacteurs(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nom TEXT,
        prenom TEXT,
        email TEXT
      )
    ''');
  }

  Future<List<Redacteur>> getAllRedacteurs() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('redacteurs');
    return maps.map((map) => Redacteur.fromMap(map)).toList();
  }

  Future<int> insertRedacteur(Redacteur redacteur) async {
    final db = await database;
    return await db.insert('redacteurs', redacteur.toMap());
  }

  Future<int> updateRedacteur(Redacteur redacteur) async {
    final db = await database;
    return await db.update(
      'redacteurs',
      redacteur.toMap(),
      where: 'id = ?',
      whereArgs: [redacteur.id],
    );
  }

  Future<int> deleteRedacteur(int id) async {
    final db = await database;
    return await db.delete('redacteurs', where: 'id = ?', whereArgs: [id]);
  }
}
