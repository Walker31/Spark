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

  Subject copyWith({
    int? id,
    String? subName,
    String? subCode,
    int? nPresent,
    int? nTotal,
    double? percent,
  }) {
    return Subject(
      id: id ?? this.id,
      subName: subName ?? this.subName,
      subCode: subCode ?? this.subCode,
      nPresent: nPresent ?? this.nPresent,
      nTotal: nTotal ?? this.nTotal,
      percent: percent ?? this.percent,
    );
  }
}
