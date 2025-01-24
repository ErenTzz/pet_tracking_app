import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/pet.dart';

class DatabaseService {
  static Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();

  final String _petsTableName = "pets";
  final String _petsIdColumnName = "id";
  final String _petsContentColumnName = "content";
  final String _petsStatusColumnName = "status";

  DatabaseService._constructor();

  Future<Database> get database async {
    if (_db != null) {
      return _db!;
    }
    _db = await getDatabase();
    return _db!;
  }

  Future<Database> getDatabase() async {
    final databasedirPath = await getDatabasesPath();
    final databasePath = join(databasedirPath, "master_db.db");
    final database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) {
        db.execute(''' CREATE TABLE $_petsTableName(
          $_petsIdColumnName INTEGER PRIMARY KEY,
          $_petsContentColumnName TEXT NOT NULL,
          $_petsStatusColumnName INTEGER NOT NULL
        )''');
      },
    );
    return database;
  }

  void addTask(
    String content,
  ) async {
    final db = await database;
    await db.insert(_petsTableName, {
      _petsContentColumnName: content,
      _petsStatusColumnName: 0,
    });
  }

  void deleteTask(int id) async {
    final db = await database;
    await db.delete(
      _petsTableName,
      where: 'id = ?',
      whereArgs: [
        id,
      ],
    );
  }

  void updateTaskStatus(int id, int status) async {
    final db = await database;
    await db.update(
      _petsTableName,
      {
        _petsStatusColumnName: status,
      },
      where: 'id = ?',
      whereArgs: [
        id,
      ],
    );
  }

  Future<List<Pet>> getTask() async {
    final db = await database;
    final data = await db.query(_petsTableName);
    List<Pet> tasks = data
        .map((e) => Pet(
            id: e["id"] as int,
            status: e["status"] as int,
            content: e["content"] as String))
        .toList();
    return tasks;
  }
}
