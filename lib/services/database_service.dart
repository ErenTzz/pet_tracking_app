import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task.dart';
import '../models/feeding_record.dart';

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

  final String _feedingRecordsTableName = "feeding_records";
  final String _feedingRecordsIdColumnName = "id";
  final String _feedingRecordsPetIdColumnName = "petId";
  final String _feedingRecordsFoodTypeColumnName = "foodType";
  final String _feedingRecordsMealTimeColumnName = "mealTime";
  final String _feedingRecordsAmountColumnName = "amount";
  final String _feedingRecordsDrankWaterColumnName = "drankWater";

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
      version: 7, // Update the version to force onUpgrade
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
        db.execute('''
          CREATE TABLE $_feedingRecordsTableName(
            $_feedingRecordsIdColumnName INTEGER PRIMARY KEY AUTOINCREMENT,
            $_feedingRecordsPetIdColumnName INTEGER NOT NULL,
            $_feedingRecordsFoodTypeColumnName TEXT NOT NULL,
            $_feedingRecordsMealTimeColumnName TEXT NOT NULL,
            $_feedingRecordsAmountColumnName REAL NOT NULL,
            $_feedingRecordsDrankWaterColumnName INTEGER NOT NULL,
            FOREIGN KEY ($_feedingRecordsPetIdColumnName) REFERENCES $_tasksTableName($_tasksIdColumnName)
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) {
        if (oldVersion < 7) {
          db.execute('''
            CREATE TABLE $_feedingRecordsTableName(
              $_feedingRecordsIdColumnName INTEGER PRIMARY KEY AUTOINCREMENT,
              $_feedingRecordsPetIdColumnName INTEGER NOT NULL,
              $_feedingRecordsFoodTypeColumnName TEXT NOT NULL,
              $_feedingRecordsMealTimeColumnName TEXT NOT NULL,
              $_feedingRecordsAmountColumnName REAL NOT NULL,
              $_feedingRecordsDrankWaterColumnName INTEGER NOT NULL,
              FOREIGN KEY ($_feedingRecordsPetIdColumnName) REFERENCES $_tasksTableName($_tasksIdColumnName)
            )
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

  Stream<List<Task>> watchTasks() async* {
    final db = await database;
    yield* db.query(_tasksTableName).asStream().map((data) => data
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
        .toList());
  }

  Future<void> addFeedingRecord(int petId, String foodType, String mealTime,
      double amount, bool drankWater) async {
    final db = await database;
    await db.insert(_feedingRecordsTableName, {
      _feedingRecordsPetIdColumnName: petId,
      _feedingRecordsFoodTypeColumnName: foodType,
      _feedingRecordsMealTimeColumnName: mealTime,
      _feedingRecordsAmountColumnName: amount,
      _feedingRecordsDrankWaterColumnName: drankWater ? 1 : 0,
    });
    print(
        'Feeding record added: $petId, $foodType, $mealTime, $amount, $drankWater');
  }

  Future<void> deleteFeedingRecord(int id) async {
    final db = await database;
    await db.delete(
      _feedingRecordsTableName,
      where: '$_feedingRecordsIdColumnName = ?',
      whereArgs: [id],
    );
    print('Feeding record deleted: $id');
  }

  Future<List<FeedingRecord>> getFeedingRecords(int petId) async {
    final db = await database;
    final data = await db.query(
      _feedingRecordsTableName,
      where: '$_feedingRecordsPetIdColumnName = ?',
      whereArgs: [petId],
    );
    List<FeedingRecord> records = data
        .map((e) => FeedingRecord(
            id: e[_feedingRecordsIdColumnName] as int,
            petId: e[_feedingRecordsPetIdColumnName] as int,
            foodType: e[_feedingRecordsFoodTypeColumnName] as String,
            mealTime: e[_feedingRecordsMealTimeColumnName] as String,
            amount: e[_feedingRecordsAmountColumnName] as double,
            drankWater: e[_feedingRecordsDrankWaterColumnName] == 1))
        .toList();
    print('Feeding records fetched: ${records.length}');
    return records;
  }
}
