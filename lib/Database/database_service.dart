import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:logger/logger.dart';
import '../Boxes/attendance_count.dart';
import '../Boxes/subject.dart';

class DatabaseHelper {
  static Database? _database;
  static final DatabaseHelper instance = DatabaseHelper._();

  final Logger logger = Logger();

  DatabaseHelper._();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, 'attendance_database.db');

    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE subjects(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        subName TEXT,
        subCode TEXT,
        nPresent INTEGER,
        nTotal INTEGER,
        percent REAL
      )
    ''');

    await db.execute('''
      CREATE TABLE attendance_counts(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        subName TEXT,
        date TEXT,
        attend INTEGER
      )
    ''');
  }

  // Subject operations

  Future<int> insertSubject(Subject subject) async {
    final db = await database;
    return await db.insert('subjects', subject.toMap());
  }

  Future<List<Subject>> getAllSubjects() async {
    final db = await database;
    var result = await db.query('subjects');
    return result.map((e) => Subject.fromMap(e)).toList();
  }

  Future<void> deleteSubject(int id) async {
    final db = await database;
    await db.delete('subjects', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateSubject(Subject subject) async {
    final db = await database;
    await db.update('subjects', subject.toMap(), where: 'id = ?', whereArgs: [subject.id]);
  }

  // Attendance operations

  Future<int> insertAttendance(AttendanceCount attendance) async {
    final db = await database;
    return await db.insert('attendance_counts', attendance.toMap());
  }

  Future<List<AttendanceCount>> getAttendanceByDate(String date) async {
    final db = await database;
    var result = await db.query('attendance_counts', where: 'date = ?', whereArgs: [date]);
    return result.map((e) => AttendanceCount.fromMap(e)).toList();
  }

  Future<void> deleteAttendance(int id) async {
    final db = await database;
    await db.delete('attendance_counts', where: 'id = ?', whereArgs: [id]);
  }

  // Additional methods

  Future<void> deleteAllAttendance() async {
    final db = await database;
    await db.delete('attendance_counts');
  }

  Future<void> deleteAllSubjects() async {
    final db = await database;
    await db.delete('subjects');
  }

  Future<void> closeDatabase() async {
    final db = await database;
    db.close();
    _database = null; // Reset the database instance
  }
}
