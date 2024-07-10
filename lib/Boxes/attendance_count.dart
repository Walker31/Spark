class AttendanceCount {
  int? id; // Change type to int
  String subName;
  String date;
  bool attend;

  AttendanceCount({
    this.id, // Change type to int
    required this.subName,
    required this.date,
    required this.attend,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id, // Use int type here
      'subName': subName,
      'date': date,
      'attend': attend ? 1 : 0,
    };
  }

  factory AttendanceCount.fromMap(Map<String, dynamic> map) {
    return AttendanceCount(
      id: map['id'], // Should match the database schema type
      subName: map['subName'],
      date: map['date'],
      attend: map['attend'] == 1,
    );
  }
}
