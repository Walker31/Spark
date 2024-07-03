import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import '../../Boxes/subject.dart';
import '../../Boxes/attendance_count.dart';

class AttendanceProvider with ChangeNotifier {
  final Logger logger = Logger();
  List<Subject> _subjects = [];
  List<AttendanceCount> _attendanceList = [];

  List<Subject> get subjects => _subjects;
  List<AttendanceCount> get attendanceList => _attendanceList;

  Future<void> fetchSubjects() async {
    final box = Hive.box<Subject>('subjects');
    _subjects = box.values.toList();
    logger.d('Fetched subjects: ${_subjects.map((subject) => subject.toJson()).toList()}');
    notifyListeners();
  }

  Future<void> fetchAttendance(String date) async {
    final attendanceBox = await Hive.openBox<AttendanceCount>('attendance_counts');
    
    try {
      final targetDate = DateFormat("dd/MM/yyyy").parseStrict(date);
      logger.d('Parsed target date: $targetDate');

      _attendanceList = attendanceBox.values.where((attendance) {
        try {
          final attendanceDate = DateFormat("dd/MM/yyyy").parseStrict(attendance.date);
          return attendanceDate == targetDate;
        } catch (e) {
          logger.e("Error parsing attendance date: ${attendance.date}, error: $e");
          return false;
        }
      }).toList();

      logger.d('Fetched attendance for date $date: ${_attendanceList.map((attendance) => attendance.toJson()).toList()}');
    } catch (e) {
      logger.e("Error parsing target date: $date, error: $e");
    }

    notifyListeners();
  }

  Future<void> addSubject(Subject subject) async {
    final box = Hive.box<Subject>('subjects');
    await box.add(subject);
    _subjects = box.values.toList();
    logger.d('Added subject: ${subject.toJson()}');
    logger.d('Current subjects: ${_subjects.map((subject) => subject.toJson()).toList()}');
    notifyListeners();
  }

  Future<void> deleteSubject(Subject subject, int index) async {
    final box = Hive.box<Subject>('subjects');
    await box.delete(subject.key);
    _subjects = box.values.toList();  // Refresh the list
    logger.d('Deleted subject at index $index: ${subject.toJson()}');
    logger.d('Current subjects: ${_subjects.map((subject) => subject.toJson()).toList()}');
    notifyListeners();  // Notify listeners to update the UI
  }

  Future<void> addAttendance(AttendanceCount attendance) async {
    final attendanceBox = await Hive.openBox<AttendanceCount>('attendance_counts');
    await attendanceBox.add(attendance);
    _attendanceList = attendanceBox.values.toList();
    logger.d('Added attendance: ${attendance.toJson()}');
    notifyListeners();
  }

  Future<void> updateSubject(Subject item) async {
    try {
      final attendanceBox = await Hive.openBox<AttendanceCount>('attendance_counts');
      final subjectBox = Hive.box<Subject>('subjects');

      final present = attendanceBox.values.where((attendance) => attendance.subName == item.subName && attendance.attend == true).length;
      final total = attendanceBox.values.where((attendance) => attendance.subName == item.subName).length;
      final percent = (total > 0) ? (present / total) * 100 : 0.0;

      item.nTotal = total;
      item.nPresent = present;
      item.percent = percent;
      await subjectBox.put(item.key, item);

      _subjects = subjectBox.values.toList();
      logger.d('Updated subject: ${item.toJson()}');
      logger.d('Current subjects: ${_subjects.map((subject) => subject.toJson()).toList()}');
      notifyListeners();
    } catch (e) {
      logger.e("Error updating subject: $e");
    }
  }
}
