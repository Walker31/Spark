// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_count.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AttendanceCountAdapter extends TypeAdapter<AttendanceCount> {
  @override
  final int typeId = 2;

  @override
  AttendanceCount read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AttendanceCount(
      id: fields[0] as String,
      subName: fields[1] as String,
      date: fields[2] as String,
      attend: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, AttendanceCount obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.subName)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.attend);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AttendanceCountAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
