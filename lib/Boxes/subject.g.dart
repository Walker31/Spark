// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subject.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SubjectAdapter extends TypeAdapter<Subject> {
  @override
  final int typeId = 1;

  @override
  Subject read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Subject(
      subName: fields[0] as String,
      subCode: fields[1] as String,
      nPresent: fields[2] as int,
      nTotal: fields[3] as int,
      percent: fields[4] as double,
      key: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Subject obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.subName)
      ..writeByte(1)
      ..write(obj.subCode)
      ..writeByte(2)
      ..write(obj.nPresent)
      ..writeByte(3)
      ..write(obj.nTotal)
      ..writeByte(4)
      ..write(obj.percent)
      ..writeByte(5)
      ..write(obj.key);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubjectAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
