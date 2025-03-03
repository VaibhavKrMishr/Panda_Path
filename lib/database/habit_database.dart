import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../screens/habit_screen.dart'; // Import your Habit class definition

class HabitDatabaseHelper {
  static final HabitDatabaseHelper instance = HabitDatabaseHelper._internal();
  factory HabitDatabaseHelper() => instance;
  HabitDatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'habit_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE habits (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        isCompleted INTEGER,  -- Store boolean as INTEGER (0 for false, 1 for true)
        completionDate TEXT -- Store DateTime as TEXT in ISO 8601 format
      )
    ''');
  }

  Future<List<Habit>> getHabits() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('habits');
    return List.generate(maps.length, (i) {
      return Habit(
        id: maps[i]['id'] as int?,
        name: maps[i]['name'] as String,
        isCompleted: maps[i]['isCompleted'] == 1, // Convert INTEGER back to boolean
        completionDate: maps[i]['completionDate'] != null
            ? DateTime.parse(maps[i]['completionDate'] as String)
            : null,
      );
    });
  }

  Future<int> insertHabit(Habit habit) async {
    Database db = await instance.database;
    return await db.insert('habits', _habitToMap(habit));
  }

  Future<int> updateHabit(Habit habit) async {
    Database db = await instance.database;
    return await db.update(
      'habits',
      _habitToMap(habit),
      where: 'id = ?',
      whereArgs: [habit.id],
    );
  }

  Future<int> deleteHabit(int id) async {
    Database db = await instance.database;
    return await db.delete(
      'habits',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Map<String, dynamic> _habitToMap(Habit habit) {
    return {
      'name': habit.name,
      'isCompleted': habit.isCompleted ? 1 : 0, // Convert boolean to INTEGER (1 or 0)
      'completionDate': habit.completionDate?.toIso8601String(), // Convert DateTime to ISO 8601 string
    };
  }
}