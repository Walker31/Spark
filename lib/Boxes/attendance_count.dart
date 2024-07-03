import 'package:hive/hive.dart';
part 'attendance_count.g.dart';

@HiveType(typeId: 2)
class AttendanceCount extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  final String subName;

  @HiveField(2)
  final String date;

  @HiveField(3)
  final bool attend;

  AttendanceCount({
    required this.id,
    required this.subName,
    required this.date,
    required this.attend,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subName': subName,
      'date': date,
      'attend': attend,
    };
  }
}
