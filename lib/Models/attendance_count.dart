import 'package:intl/intl.dart';

class AttendanceCount {
  int? id; // Id type is int
  String subName;
  DateTime date;
  bool attend;

  AttendanceCount({
    this.id, // Id type is int
    required this.subName,
    required this.date,
    required this.attend,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id, // Id type is int
      'subName': subName,
      'date': DateFormat('yyyy-MM-dd').format(date), // Store only the date part
      'attend': attend ? 1 : 0,
    };
  }

  factory AttendanceCount.fromMap(Map<String, dynamic> map) {
    return AttendanceCount(
      id: map['id'], // Id type is int
      subName: map['subName'],
      date: DateTime.parse(map['date']), // Parse only the date part
      attend: map['attend'] == 1,
    );
  }

  AttendanceCount copy({
    int? id,
    String? subName,
    DateTime? date,
    bool? attend,
  }) {
    return AttendanceCount(
      id: id ?? this.id,
      subName: subName ?? this.subName,
      date: date ?? this.date,
      attend: attend ?? this.attend,
    );
  }
}
