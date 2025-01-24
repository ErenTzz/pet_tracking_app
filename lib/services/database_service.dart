import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task.dart';

class DatabaseService {
  static Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();

  final String _tasksTableName = "tasks";
  final String _tasksIdColumnName = "id";
  final String _tasksContentColumnName = "content";
  final String _tasksTypeColumnName = "type";
  final String _tasksPhotoPathColumnName = "photoPath";
  final String _tasksStatusColumnName = "status";

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
      version: 3, // Update the version to force onUpgrade
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE $_tasksTableName(
            $_tasksIdColumnName INTEGER PRIMARY KEY AUTOINCREMENT,
            $_tasksContentColumnName TEXT NOT NULL,
            $_tasksTypeColumnName TEXT NOT NULL,
            $_tasksPhotoPathColumnName TEXT NOT NULL,
            $_tasksStatusColumnName INTEGER NOT NULL
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) {
        if (oldVersion < 2) {
          db.execute('''
            ALTER TABLE $_tasksTableName ADD COLUMN $_tasksTypeColumnName TEXT NOT NULL DEFAULT ''
          ''');
        }
        if (oldVersion < 3) {
          db.execute('''
            ALTER TABLE $_tasksTableName ADD COLUMN $_tasksPhotoPathColumnName TEXT NOT NULL DEFAULT ''
          ''');
        }
      },
    );
    return database;
  }

  Future<void> addTask(String content, String type, String photoPath) async {
    final db = await database;
    await db.insert(_tasksTableName, {
      _tasksContentColumnName: content,
      _tasksTypeColumnName: type,
      _tasksPhotoPathColumnName: photoPath,
      _tasksStatusColumnName: 0,
    });
    // print('Task added: $content, $type, $photoPath');
  }

  Future<void> deleteTask(int id) async {
    final db = await database;
    await db.delete(
      _tasksTableName,
      where: '$_tasksIdColumnName = ?',
      whereArgs: [id],
    );
    // print('Task deleted: $id');
  }

  Future<void> updateTaskStatus(int id, int status) async {
    final db = await database;
    await db.update(
      _tasksTableName,
      {
        _tasksStatusColumnName: status,
      },
      where: '$_tasksIdColumnName = ?',
      whereArgs: [id],
    );
  }

  Future<List<Task>> getTask() async {
    final db = await database;
    final data = await db.query(_tasksTableName);
    List<Task> tasks = data
        .map((e) => Task(
            id: e[_tasksIdColumnName] as int,
            content: e[_tasksContentColumnName] as String? ?? '',
            type: e[_tasksTypeColumnName] as String? ?? '',
            photoPath: e[_tasksPhotoPathColumnName] as String? ?? '',
            status: e[_tasksStatusColumnName] as int))
        .toList();
    // print('Tasks fetched: ${tasks.length}');
    tasks.forEach((task) {
      // print('Fetched task: ${task.content}, ${task.type}, ${task.photoPath}');
    });
    return tasks;
  }
}
