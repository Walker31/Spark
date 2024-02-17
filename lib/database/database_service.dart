import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:spark/database/subject_db.dart';

class DatabaseService {
  static Database? _database;
  final Logger _logger = Logger();
  bool _isInitialized = false;
  String name = 'Subject.db';
  String tableName1 = 'subject_details';
  String tableName2 = 'AttendanceCount';
  String tableName3 = 'date_sheets';

  Future<void> init() async {
    await _initialize();
  }

  Future<String> get _fullPath async {
    final path = await getDatabasesPath();
    return join(path, name);
  }

  Future<void> _initialize() async {
    if (_isInitialized) {
      return; // Skip initialization if already done
    }

    final path = await _fullPath;

    try {
      _database = await openDatabase(
        path,
        version: 7,
        onCreate: _createTables,
        onUpgrade: _onUpgrade,
      );
      _isInitialized = true;
    } catch (e) {
      _logger.e('Error initializing database: $e');
      rethrow; // Propagate the error after logging
    }
  }

  Future<void> _createTables(Database db, int version) async {
    var subjectDB = SubjectDB();
    await subjectDB.createTable(db);
    await subjectDB.createTable2(db);
    await subjectDB.createTable3(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion == 6 && newVersion == 7) {
      var subjectDB = SubjectDB();
      await db.execute('DROP TABLE IF EXISTS $tableName1');
      await db.execute('DROP TABLE IF EXISTS $tableName2');
      await db.execute('DROP TABLE IF EXISTS $tableName3');
      await subjectDB.createTable(db);
      await subjectDB.createTable2(db);
      await subjectDB.createTable3(db);
    }
  }

  Future<Database> get database async {
    await _initialize();
    return _database!;
  }

  Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
