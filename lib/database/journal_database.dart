import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../screens/journal_screen.dart'; 

class JournalDatabaseHelper {
  static final JournalDatabaseHelper instance = JournalDatabaseHelper._internal();
  factory JournalDatabaseHelper() => instance;
  JournalDatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'journal_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE journal_entries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        subject TEXT,
        text TEXT,
        dateTime TEXT
      )
    ''');
  }

  Future<List<JournalEntry>> getJournalEntries() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('journal_entries', orderBy: 'dateTime DESC');
    return List.generate(maps.length, (i) {
      return JournalEntry(
        id: maps[i]['id'] as int?, // Include id
        subject: maps[i]['subject'] as String,
        text: maps[i]['text'] as String,
        dateTime: DateTime.parse(maps[i]['dateTime'] as String),
      );
    });
  }

  Future<int> insertJournalEntry(JournalEntry entry) async {
    Database db = await instance.database;
    return await db.insert('journal_entries', _journalEntryToMap(entry));
  }

  Future<int> updateJournalEntry(JournalEntry entry) async {
    Database db = await instance.database;
    return await db.update(
      'journal_entries',
      _journalEntryToMap(entry),
      where: 'id = ?',
      whereArgs: [entry.id], // Use id for update
    );
  }

  Future<int> deleteJournalEntry(int id) async {
    Database db = await instance.database;
    return await db.delete(
      'journal_entries',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Map<String, dynamic> _journalEntryToMap(JournalEntry entry) {
    return {
      'subject': entry.subject,
      'text': entry.text,
      'dateTime': entry.dateTime.toIso8601String(),
    };
  }
}