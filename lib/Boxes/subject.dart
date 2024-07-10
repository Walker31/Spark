class Subject {
  int? id; // Nullable for SQLite auto-increment
  String subName;
  String subCode;
  int nPresent;
  int nTotal;
  double percent;

  Subject({
    this.id,
    required this.subName,
    required this.subCode,
    required this.nPresent,
    required this.nTotal,
    required this.percent,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subName': subName,
      'subCode': subCode,
      'nPresent': nPresent,
      'nTotal': nTotal,
      'percent': percent,
    };
  }

  factory Subject.fromMap(Map<String, dynamic> map) {
    return Subject(
      id: map['id'],
      subName: map['subName'],
      subCode: map['subCode'],
      nPresent: map['nPresent'],
      nTotal: map['nTotal'],
      percent: map['percent'],
    );
  }
}
