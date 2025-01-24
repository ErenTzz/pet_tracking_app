import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task.dart';

class DatabaseService {
  static Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();

  final String _tasksTableName = "tasks";
  final String _tasksIdColumnName = "id";
  final String _tasksNameColumnName = "name";
  final String _tasksTypeColumnName = "type";
  final String _tasksAgeColumnName = "age";
  final String _tasksBreedColumnName = "breed";
  final String _tasksPhotoPathColumnName = "photoPath";
  final String _tasksWeightColumnName = "weight";
  final String _tasksHealthStatusColumnName = "healthStatus";
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
      version: 6, // Update the version to force onUpgrade
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE $_tasksTableName(
            $_tasksIdColumnName INTEGER PRIMARY KEY AUTOINCREMENT,
            $_tasksNameColumnName TEXT NOT NULL,
            $_tasksTypeColumnName TEXT NOT NULL,
            $_tasksAgeColumnName INTEGER NOT NULL,
            $_tasksBreedColumnName TEXT NOT NULL,
            $_tasksPhotoPathColumnName TEXT NOT NULL,
            $_tasksWeightColumnName REAL NOT NULL,
            $_tasksHealthStatusColumnName TEXT NOT NULL,
            $_tasksStatusColumnName INTEGER NOT NULL
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) {
        if (oldVersion < 6) {
          db.execute('''
            ALTER TABLE $_tasksTableName ADD COLUMN $_tasksNameColumnName TEXT NOT NULL DEFAULT ''
          ''');
          db.execute('''
            ALTER TABLE $_tasksTableName ADD COLUMN $_tasksAgeColumnName INTEGER NOT NULL DEFAULT 0
          ''');
          db.execute('''
            ALTER TABLE $_tasksTableName ADD COLUMN $_tasksBreedColumnName TEXT NOT NULL DEFAULT ''
          ''');
          db.execute('''
            ALTER TABLE $_tasksTableName ADD COLUMN $_tasksWeightColumnName REAL NOT NULL DEFAULT 0.0
          ''');
          db.execute('''
            ALTER TABLE $_tasksTableName ADD COLUMN $_tasksHealthStatusColumnName TEXT NOT NULL DEFAULT ''
          ''');
        }
      },
    );
    return database;
  }

  Future<void> addTask(String name, String type, int age, String breed,
      String photoPath, double weight, String healthStatus) async {
    final db = await database;
    await db.insert(_tasksTableName, {
      _tasksNameColumnName: name,
      _tasksTypeColumnName: type,
      _tasksAgeColumnName: age,
      _tasksBreedColumnName: breed,
      _tasksPhotoPathColumnName: photoPath,
      _tasksWeightColumnName: weight,
      _tasksHealthStatusColumnName: healthStatus,
      _tasksStatusColumnName: 0,
    });
    print(
        'Task added: $name, $type, $age, $breed, $photoPath, $weight, $healthStatus');
  }

  Future<void> deleteTask(int id) async {
    final db = await database;
    await db.delete(
      _tasksTableName,
      where: '$_tasksIdColumnName = ?',
      whereArgs: [id],
    );
    print('Task deleted: $id');
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
            name: e[_tasksNameColumnName] as String? ?? '',
            type: e[_tasksTypeColumnName] as String? ?? '',
            age: e[_tasksAgeColumnName] as int? ?? 0,
            breed: e[_tasksBreedColumnName] as String? ?? '',
            photoPath: e[_tasksPhotoPathColumnName] as String? ?? '',
            weight: e[_tasksWeightColumnName] as double? ?? 0.0,
            healthStatus: e[_tasksHealthStatusColumnName] as String? ?? '',
            status: e[_tasksStatusColumnName] as int))
        .toList();
    print('Tasks fetched: ${tasks.length}');
    tasks.forEach((task) {
      print(
          'Fetched task: ${task.name}, ${task.type}, ${task.age}, ${task.breed}, ${task.photoPath}, ${task.weight}, ${task.healthStatus}');
    });
    return tasks;
  }
}
