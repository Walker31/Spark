import 'package:flutter/material.dart';
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
      logger.d('Fetched subjects: ${_subjects.map((subject) => subject.toMap()).toList()}');
      notifyListeners();
    } catch (e) {
      logger.e('Error fetching subjects: $e');
    }
  }

  Future<void> fetchAttendance(String date) async {
    try {
      _attendanceList = await _databaseHelper.getAttendanceByDate(date);
      logger.d('Fetched attendance for date $date: ${_attendanceList.map((attendance) => attendance.toMap()).toList()}');
      notifyListeners();
    } catch (e) {
      logger.e('Error fetching attendance for date $date: $e');
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

  Future<void> deleteSubject(int id) async {
    try {
      await _databaseHelper.deleteSubject(id);
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
      _attendanceList = await _databaseHelper.getAttendanceByDate(attendance.date);
      logger.d('Added attendance: ${attendance.toMap()}');
      await updateSubjectsFromAttendance();
      notifyListeners();
    } catch (e) {
      logger.e('Error adding attendance: $e');
    }
  }

  Future<void> updateSubject(Subject subject) async {
    try {
      await _databaseHelper.updateSubject(subject);
      _subjects = await _databaseHelper.getAllSubjects();
      logger.d('Updated subject: ${subject.toMap()}');
      notifyListeners();
    } catch (e) {
      logger.e('Error updating subject: $e');
    }
  }

  Future<void> updateSubjectsFromAttendance() async {
    try {
      // Group attendance by subject name
      Map<String, List<AttendanceCount>> attendanceBySubject = {};
      for (var attendance in _attendanceList) {
        if (!attendanceBySubject.containsKey(attendance.subName)) {
          attendanceBySubject[attendance.subName] = [];
        }
        attendanceBySubject[attendance.subName]!.add(attendance);
      }

      // Update each subject's attendance statistics
      for (var subjectName in attendanceBySubject.keys) {
        List<AttendanceCount> attendances = attendanceBySubject[subjectName]!;
        
        // Calculate total attendance count
        int totalAttendance = attendances.where((attendance) => attendance.attend).length;

        // Update the subject's attendance statistics
        Subject updatedSubject = _subjects.firstWhere((subject) => subject.subName == subjectName);
        updatedSubject.nPresent = totalAttendance;
        updatedSubject.nTotal = attendances.length;
        updatedSubject.percent = (totalAttendance / attendances.length) * 100;

        // Save updated subject to the database
        await _databaseHelper.updateSubject(updatedSubject);
      }

      // Fetch updated list of subjects after update
      _subjects = await _databaseHelper.getAllSubjects();
      notifyListeners();
    } catch (e) {
      logger.e('Error updating subjects from attendance: $e');
    }
  }
}

