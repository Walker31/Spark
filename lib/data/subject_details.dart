class Subject{
  final int id;
  final String subName;
  final String subCode;
  int nPresent;
  int nTotal;
  double percent;

  Subject({
    required this.id,
    required this.subName,
    required this.subCode,
    required this.nPresent,
    required this.nTotal,
    required this.percent
  });

   Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subName': subName,
      'subCode': subCode,
      'nPresent':nPresent,
      'nTotal':nTotal,
      'percent':percent
    };
  }

  factory Subject.fromSqfliteDatabase(Map<String,dynamic> map) =>Subject(
    id: map['id']?.toInt()?? 0,
    subName: map['subName'] ??'',
    nPresent: map['nPresent']?? 0,
    subCode: map['subCode']?? '',
    nTotal: map['nTotal']?? 0,
    percent: map['percent']?? 0.0
    );

  @override
  String toString() {
    return 'Subject{id: $id, subName: $subName, subCode: $subCode,nPresent: $nPresent,nTotal: $nTotal,percent: $percent}';
  }
  
}

class AttendanceCount{
   final String subName;
   final String date;
   final bool attend;

   const AttendanceCount({
    required this.attend,
    required this.date,
    required this.subName
   });

   Map<String, dynamic> toMap() {
    return {
      'subName': subName,
      'date': date,
      'attend':attend,
    };
  }

  @override
  String toString() {
    return 'AttendanceCount{ subName: $subName, date: $date,attend: $attend}';
  }
  
  factory AttendanceCount.fromSqfliteDatabase(Map<String, dynamic> map) => AttendanceCount(
    subName: map['subName'] ?? '',
    date: map['date']?? '',
    attend: map['attend'] == 1,
  );
}

