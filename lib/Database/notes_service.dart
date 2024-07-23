import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:spark/Models/notes_model.dart';

class NotesDatabase {
  static final NotesDatabase instance = NotesDatabase._init();

  static Database? _database;

  NotesDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const dateTimeType = 'TEXT NOT NULL';

    await db.execute('''
CREATE TABLE notes ( 
  id $idType, 
  title $textType,
  content $textType,
  timestamp $dateTimeType
  )
''');
  }

  Future<List<Notes>> getAllNotes() async {
    final db = await instance.database;

    final result = await db.query('notes');

    return result.map((json) => Notes.fromMap(json)).toList();
  }

  Future<int> insertNote(Notes note) async {
    final db = await instance.database;

    return await db.insert('notes', note.toMap());
  }

  Future<int> updateNote(Notes note) async {
    final db = await instance.database;

    return await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> deleteNote(int id) async {
    final db = await instance.database;

    return await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
