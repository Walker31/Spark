import 'package:hive_flutter/hive_flutter.dart';

part 'subject.g.dart';

@HiveType(typeId: 1)
class Subject {
  Subject({
    required this.subName,
    required this.subCode,  
    required this.nPresent,
    required this.nTotal,
    required this.percent,
    required this.key, // Add this field
  });

  @HiveField(0)
  String subName;
  
  @HiveField(1)
  String subCode;

  @HiveField(2)
  int nPresent;

  @HiveField(3)
  int nTotal;

  @HiveField(4)
  double percent;

  @HiveField(5) // Add this annotation
  int key; // Add this field

  Map<String, dynamic> toJson() {
    return {
      'subName': subName,
      'subCode': subCode,
      'nPresent': nPresent,
      'nTotal': nTotal,
      'percent': percent,
      'key': key,
    };
  }
}
