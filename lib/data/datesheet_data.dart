class DateSheet{
  final String day;
  final String subName;
  final String fromTime;
  final String toTime;

  DateSheet({
    required this.day,
    required this.subName,
    required this.fromTime,
    required this.toTime
  });

  Map<String, dynamic> toMap(){
    return {
      'day': day,
      'subName': subName,
      'fromTime' : fromTime,
      'toTime': toTime
    };
  }

factory DateSheet.fromSqfliteDatabase(Map<String,dynamic> map) => DateSheet(
  day: map['day']?? '',
  subName: map['subName']?? '',
  fromTime: map['fromTime']?? '',
  toTime: map['toTime']?? ''
  );

  @override
  String toString(){
    return 'DateSheet{day: $day, subName: $subName,fromTime: $fromTime, toTime: $toTime}';
  }
}