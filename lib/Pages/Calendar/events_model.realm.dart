// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'events_model.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class Event extends _Event with RealmEntity, RealmObjectBase, RealmObject {
  Event(
    String id,
    String subjectName,
    String eventType,
    DateTime eventTime,
    DateTime eventDate,
  ) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'subjectName', subjectName);
    RealmObjectBase.set(this, 'eventType', eventType);
    RealmObjectBase.set(this, 'eventTime', eventTime);
    RealmObjectBase.set(this, 'eventDate', eventDate);
  }

  Event._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get subjectName =>
      RealmObjectBase.get<String>(this, 'subjectName') as String;
  @override
  set subjectName(String value) =>
      RealmObjectBase.set(this, 'subjectName', value);

  @override
  String get eventType =>
      RealmObjectBase.get<String>(this, 'eventType') as String;
  @override
  set eventType(String value) => RealmObjectBase.set(this, 'eventType', value);

  @override
  DateTime get eventTime =>
      RealmObjectBase.get<DateTime>(this, 'eventTime') as DateTime;
  @override
  set eventTime(DateTime value) =>
      RealmObjectBase.set(this, 'eventTime', value);

  @override
  DateTime get eventDate =>
      RealmObjectBase.get<DateTime>(this, 'eventDate') as DateTime;
  @override
  set eventDate(DateTime value) =>
      RealmObjectBase.set(this, 'eventDate', value);

  @override
  Stream<RealmObjectChanges<Event>> get changes =>
      RealmObjectBase.getChanges<Event>(this);

  @override
  Stream<RealmObjectChanges<Event>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<Event>(this, keyPaths);

  @override
  Event freeze() => RealmObjectBase.freezeObject<Event>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'subjectName': subjectName.toEJson(),
      'eventType': eventType.toEJson(),
      'eventTime': eventTime.toEJson(),
      'eventDate': eventDate.toEJson(),
    };
  }

  static EJsonValue _toEJson(Event value) => value.toEJson();
  static Event _fromEJson(EJsonValue ejson) {
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'subjectName': EJsonValue subjectName,
        'eventType': EJsonValue eventType,
        'eventTime': EJsonValue eventTime,
        'eventDate': EJsonValue eventDate,
      } =>
        Event(
          fromEJson(id),
          fromEJson(subjectName),
          fromEJson(eventType),
          fromEJson(eventTime),
          fromEJson(eventDate),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Event._);
    register(_toEJson, _fromEJson);
    return SchemaObject(ObjectType.realmObject, Event, 'Event', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('subjectName', RealmPropertyType.string),
      SchemaProperty('eventType', RealmPropertyType.string),
      SchemaProperty('eventTime', RealmPropertyType.timestamp),
      SchemaProperty('eventDate', RealmPropertyType.timestamp),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class Schedule extends _Schedule
    with RealmEntity, RealmObjectBase, RealmObject {
  Schedule(
    String id,
    String day,
    String subjectName,
    DateTime eventTime,
    String eventType,
  ) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'day', day);
    RealmObjectBase.set(this, 'subjectName', subjectName);
    RealmObjectBase.set(this, 'eventTime', eventTime);
    RealmObjectBase.set(this, 'eventType', eventType);
  }

  Schedule._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get day => RealmObjectBase.get<String>(this, 'day') as String;
  @override
  set day(String value) => RealmObjectBase.set(this, 'day', value);

  @override
  String get subjectName =>
      RealmObjectBase.get<String>(this, 'subjectName') as String;
  @override
  set subjectName(String value) =>
      RealmObjectBase.set(this, 'subjectName', value);

  @override
  DateTime get eventTime =>
      RealmObjectBase.get<DateTime>(this, 'eventTime') as DateTime;
  @override
  set eventTime(DateTime value) =>
      RealmObjectBase.set(this, 'eventTime', value);

  @override
  String get eventType =>
      RealmObjectBase.get<String>(this, 'eventType') as String;
  @override
  set eventType(String value) => RealmObjectBase.set(this, 'eventType', value);

  @override
  Stream<RealmObjectChanges<Schedule>> get changes =>
      RealmObjectBase.getChanges<Schedule>(this);

  @override
  Stream<RealmObjectChanges<Schedule>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<Schedule>(this, keyPaths);

  @override
  Schedule freeze() => RealmObjectBase.freezeObject<Schedule>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'day': day.toEJson(),
      'subjectName': subjectName.toEJson(),
      'eventTime': eventTime.toEJson(),
      'eventType': eventType.toEJson(),
    };
  }

  static EJsonValue _toEJson(Schedule value) => value.toEJson();
  static Schedule _fromEJson(EJsonValue ejson) {
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'day': EJsonValue day,
        'subjectName': EJsonValue subjectName,
        'eventTime': EJsonValue eventTime,
        'eventType': EJsonValue eventType,
      } =>
        Schedule(
          fromEJson(id),
          fromEJson(day),
          fromEJson(subjectName),
          fromEJson(eventTime),
          fromEJson(eventType),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Schedule._);
    register(_toEJson, _fromEJson);
    return SchemaObject(ObjectType.realmObject, Schedule, 'Schedule', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('day', RealmPropertyType.string),
      SchemaProperty('subjectName', RealmPropertyType.string),
      SchemaProperty('eventTime', RealmPropertyType.timestamp),
      SchemaProperty('eventType', RealmPropertyType.string),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
