import 'package:intl/intl.dart';
import 'package:spark/data/datesheet_data.dart';
import 'package:sqflite/sqflite.dart';
import 'package:logger/logger.dart';
import 'package:spark/database/database_service.dart';
import 'package:spark/data/subject_details.dart';

class SubjectDB{
  final Logger _logger = Logger();
  final tableName1='subject_details';
  final tableName2='AttendanceCount';
  final tableName3 = 'date_sheets';
  


  void log(String message) {
    _logger.d(message);
  }


  Future<void> createTable(Database database) async {
  log('Creating $tableName1 table...');
  await database.execute("""CREATE TABLE IF NOT EXISTS $tableName1 (
    "id" INTEGER NOT NULL,
    "subName" TEXT NOT NULL,
    "subCode" TEXT NOT NULL,
    "nPresent" INTEGER,
    "nTotal" INTEGER,
    "percent" REAL,  -- Add the percent column here
    PRIMARY KEY("id" AUTOINCREMENT)
  );""");
  log('$tableName1 table created.');
}

  Future<void> createTable2(Database database) async {
    log('Creating $tableName2 table...');
    await database.execute("""Create Table IF NOT EXISTS $tableName2(
      "subName" TEXT NOT NULL,
      "date" TEXT NOT NULL ,
      "attend" BOOLEAN
    );""");
    log('$tableName2 table created.');
  }

  Future<void> createTable3(Database database) async {
    log('Creating $tableName3 table...');
    await database.execute("""CREATE TABLE IF NOT EXISTS $tableName3 (
      "id" INTEGER NOT NULL,
      "day" TEXT NOT NULL,
      "subName" TEXT NOT NULL,
      "fromTime" TEXT NOT NULL,
      "toTime" TEXT NOT NULL,
      PRIMARY KEY("id" AUTOINCREMENT)
    );""");
    log('$tableName3 table created.');
  }

  Future<int> create1({required String subName,required String subCode}) async {
     log('Creating record in $tableName1 table...');
    final database=await DatabaseService().database;
     log('Record created in $tableName1 table.');
    return await database.rawInsert(
      '''INSERT INTO $tableName1(subName,subCode,nPresent,nTotal) VALUES(?,?,?,?)''',
      [subName,subCode,0,0],
    );
  }

  Future<int> create2({required String subName, required String date, required bool attend}) async {
  log('Creating record in $tableName2 table...');
  DateTime originalDate = DateTime.parse(date);
  String formattedDate = DateFormat('dd/MM/yyyy').format(originalDate);
  final database = await DatabaseService().database;
  final attendValue = attend ? 1 : 0;
    log('Record created in $tableName2 table.');
  return await database.rawInsert(
    '''INSERT INTO $tableName2(subName, date, attend) VALUES(?,?,?)''',
    [subName, formattedDate, attendValue],
  );
}

Future<int> create3({required String day, required String subName, required String fromTime, required String toTime}) async {
    log('Creating record in $tableName3 table...');
    final database = await DatabaseService().database;
    log('Record created in $tableName3 table.');
    return await database.rawInsert(
      '''INSERT INTO $tableName3(day,subName,fromTime,toTime) VALUES(?,?,?,?)''',
      [day, subName, fromTime, toTime],
    );
  }

  Future<List<DateSheet>> fetchAllDateSheets() async {
    final database = await DatabaseService().database;
    final dateSheets = await database.rawQuery('''SELECT * FROM $tableName3''');
    _logger.d('Fetched date sheets: $dateSheets');
    return dateSheets.map((map) => DateSheet.fromSqfliteDatabase(map)).toList();
  }

  Future<List<Subject>> fetchAll() async{
    final database= await DatabaseService().database;
    final subject=await database.rawQuery(
      '''SELECT * FROM $tableName1 where subName is NOT NULL''');
       _logger.d('Fetched subjects: $subject');
    return subject.map((subjectDetails)=> Subject.fromSqfliteDatabase(subjectDetails)).toList();
  }

  Future<void> deleteDateSheet(String subName) async {
    final database = await DatabaseService().database;
    await database.rawDelete('DELETE FROM $tableName3 WHERE subName = ?', [subName]);
  }

  Future<List<DateSheet>> fetchDateSheetsByDay(String dayName) async {
  final database = await DatabaseService().database;
  final dateSheets = await database.rawQuery(
    'SELECT * FROM $tableName3 WHERE day = ?',
    [dayName],
  );
  _logger.d('Fetched date sheets for $dayName: $dateSheets');
  return dateSheets.map((map) => DateSheet.fromSqfliteDatabase(map)).toList();
}

Future<List> fetchSubjects() async {
  final database = await DatabaseService().database;
  final subjects = await database.rawQuery(
    'SELECT subName from $tableName1'
  );
  _logger.d('Fetched Data : $subjects');
  return  subjects.map((map) => Subject.fromSqfliteDatabase(map)).toList();
 
}

  Future<List<AttendanceCount>> fetchAttendance() async{
    final database= await DatabaseService().database;
    final attendanceCount= await database.rawQuery(
      '''SELECT * FROM $tableName2 where subName is not NULL''');
      _logger.d(attendanceCount);
    return attendanceCount.map((subjectDetails)=> AttendanceCount.fromSqfliteDatabase(subjectDetails)).toList();
  }

  Future<List<AttendanceCount>> getAttendanceOnDate(String date) async{
    final database= await DatabaseService().database;
    final attendance= await database.rawQuery(
      'SELECT * FROM $tableName2 WHERE date = ?',
      [date],
    );
    log('Fetched attendance counts for date: $date - $attendance');
    return attendance.map((subjectDetails)=> AttendanceCount.fromSqfliteDatabase(subjectDetails)).toList();
  }
  
  Future<List<AttendanceCount>> fetchHistory(String subName) async{
    final database= await DatabaseService().database;
    final attendance= await database.rawQuery(
      'SELECT * FROM $tableName2 where subName= ?',
      [subName],
    );
    log('Fetched attendance history for subject: $subName - $attendance');
    return attendance.map((subjectDetails)=> AttendanceCount.fromSqfliteDatabase(subjectDetails)).toList();
  }

  Future<Subject> fetchbyId(int id) async{
    final database =await DatabaseService().database;
    final subject =await database
    .rawQuery('''SELECT * from $tableName1 WHERE id =? and subName is not NULL''',[id]);
    log('Fetched subject by ID: $id - $subject');
    return Subject.fromSqfliteDatabase(subject.first);
  }

  Future<int> update({String? subName, int? nTotal, int? nPresent, double? percent}) async {
  final database = await DatabaseService().database;
  return await database.update(
    tableName1,
    {
      'nTotal': nTotal,
      'nPresent': nPresent,
      'percent': percent,
    },
    where: 'subName = ?',
    whereArgs: [subName],
  );
}

  Future<int> countPresent({required String? subName}) async {
  final database = await DatabaseService().database;
  final countP = Sqflite.firstIntValue(await database.rawQuery(
    'SELECT COUNT(*) FROM $tableName2 WHERE SubName = ? AND attend = 1',
    [subName],
  ));
  return countP ?? 0;
}

  Future<int> countTotal({required String? subName}) async {
  final database = await DatabaseService().database;
  final countP = Sqflite.firstIntValue(await database.rawQuery(
    'SELECT COUNT(*) FROM $tableName2 WHERE SubName = ?',
    [subName],
  ));
  return countP ?? 0;
}

  Future<void> delete(String subName) async {
  final database = await DatabaseService().database;
  await database.rawDelete('DELETE FROM $tableName1 WHERE subName = ?', [subName]);
  await database.rawDelete('DELETE FROM $tableName2 WHERE subName = ?', [subName]);
}

Future<int> updateDateSheet(String day, String subName, String from, String to) async {
  final database = await DatabaseService().database;
  return await database.update(
    tableName3,
    {
      'day': day,
      'subName': subName,
      'fromTime': from,
      'toTime': to,
    },
    where: 'subName = ?',
    whereArgs: [subName],
  );
}


}