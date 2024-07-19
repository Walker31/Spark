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
      'date': date.toIso8601String(),
      'attend': attend ? 1 : 0,
    };
  }

  factory AttendanceCount.fromMap(Map<String, dynamic> map) {
    return AttendanceCount(
      id: map['id'], // Id type is int
      subName: map['subName'],
      date: DateTime.parse(map['date']),
      attend: map['attend'] == 1,
    );
  }
}
