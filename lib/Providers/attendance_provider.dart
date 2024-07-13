import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import '../Boxes/attendance_count.dart';
import '../Boxes/subject.dart';
import '../Database/database_service.dart';

class AttendanceProvider with ChangeNotifier {
  final Logger logger = Logger();
  List<Subject> _subjects = [];
  List<AttendanceCount> _attendanceList = [];

  List<Subject> get subjects => _subjects;
  List<AttendanceCount> get attendanceList => _attendanceList;

  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  Future<void> fetchSubjects() async {
    try {
      _subjects = await _databaseHelper.getAllSubjects();
      logger.d(
          'Fetched subjects: ${_subjects.map((subject) => subject.toMap()).toList()}');
      notifyListeners();
    } catch (e) {
      logger.e('Error fetching subjects: $e');
    }
  }

  String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  Future<void> fetchAttendance(DateTime date) async {
    try {
      _attendanceList = await _databaseHelper.getAttendanceByDate(date);
      logger.d(
          'Fetched attendance for date $date: ${_attendanceList.map((attendance) => attendance.toMap()).toList()}');
      notifyListeners();
    } catch (e) {
      logger.e('Error fetching attendance for date $date: $e');
    }
  }

  Future<Subject?> getSubject(int id) async {
    try {
      var result = await _databaseHelper.getSubject(id);

      return result;
    } catch (e) {
      logger.e('Error fetching subject with ID $id: $e');
      return null;
    }
  }

  Future<void> addSubject(Subject subject) async {
    try {
      await _databaseHelper.insertSubject(subject);
      _subjects = await _databaseHelper.getAllSubjects();
      logger.d('Added subject: ${subject.toMap()}');
      notifyListeners();
    } catch (e) {
      logger.e('Error adding subject: $e');
    }
  }

  Future<List<AttendanceCount>> fetchAttendanceForSubject(
      String subName) async {
    try {
      _attendanceList = await _databaseHelper.getAttendanceBySubject(subName);
      logger.d(
          'Fetched attendance for subject $subName: ${_attendanceList.map((attendance) => attendance.toMap()).toList()}');
      notifyListeners();
      return _attendanceList; // Ensure to return the fetched list
    } catch (e) {
      logger.e('Error fetching attendance for subject $subName: $e');
      rethrow; // Rethrow the error to propagate it to the caller
    }
  }

  Future<void> deleteSubject(int id) async {
    try {
      await _databaseHelper.deleteSubject(
        id,
      );
      _subjects = await _databaseHelper.getAllSubjects();

      logger.d('Deleted subject with ID: $id');
      notifyListeners();
    } catch (e) {
      logger.e('Error deleting subject: $e');
    }
  }

  Future<void> addAttendance(AttendanceCount attendance) async {
    try {
      await _databaseHelper.insertAttendance(attendance);
      _attendanceList =
          await _databaseHelper.getAttendanceByDate(attendance.date);
      await _databaseHelper.updateSubjectAttendance(attendance.subName);
      logger.d('Added attendance: ${attendance.toMap()}');
      notifyListeners();
    } catch (e) {
      logger.e('Error adding attendance: $e');
    }
  }

  Future<void> deleteAttendance(int id) async {
    try {
      await _databaseHelper.deleteAttendance(id);
      _attendanceList =
          await _databaseHelper.getAttendanceByDate(DateTime.now());
      logger.d('Deleted attendance with ID: $id');
      notifyListeners();
    } catch (e) {
      logger.e('Error deleting attendance: $e');
    }
  }

  updateSubject(Subject updatedSubject) {}

  // Add additional methods to delete all attendance and subjects if needed
}
