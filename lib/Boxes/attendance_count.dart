import 'package:hive_flutter/hive_flutter.dart';

part 'attendance_count.g.dart';

@HiveType(typeId: 2)
class AttendanceCount extends HiveObject {
  @HiveField(0)
  String id; // Add id field

  @HiveField(1)
  final String subName;

  @HiveField(2)
  final String date;

  @HiveField(3)
  final bool attend;

  AttendanceCount({
    required this.id, // Update constructor to accept id
    required this.subName,
    required this.date,
    required this.attend,
  });
}
