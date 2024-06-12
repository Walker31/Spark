import 'package:realm/realm.dart';

part 'events_model.realm.dart';

@RealmModel()
class _Event {
  @PrimaryKey()
  late String id;
  late String subjectName;
  late String eventType;
  late DateTime eventTime;
  late DateTime eventDate;
}

@RealmModel()
class _Schedule {
  @PrimaryKey()
  late String id;
  late String day;
  late String subjectName;
  late DateTime eventTime;
  late String eventType;
}
