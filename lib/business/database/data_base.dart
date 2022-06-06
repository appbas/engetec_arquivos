import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class EngeeTechDatabase {
  static final EngeeTechDatabase instance = EngeeTechDatabase._init();

  EngeeTechDatabase._init();

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await _initDB('engeetech.db');
    return _database;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    final database =
        await openDatabase(path, version: 1, onCreate: _onCreateDB);
    return database;
  }

  Future<void> _onCreateDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE dado_arquivo (
        _id INTEGER PRIMARY KEY AUTOINCREMENT,
        path TEXT NOT NULL,
        nome TEXT NOT NULL,
        tamanho INTEGER NOT NULL,
        hash TEXT NOT NULL,
        dataHoraCadastro TEXT,
        dataHoraEnvio TEXT,
        base64 BLOB
      )
    ''');
  }

  Future close() async {
    final db = await instance.database;
    db?.close();
  }
}
