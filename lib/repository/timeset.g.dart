// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timeset.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TimeSetInHiveAdapter extends TypeAdapter<TimeSet> {
  @override
  final int typeId = 0;

  @override
  TimeSet read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TimeSet(
      title: fields[0] as String,
      startHours: fields[6] as int,
      startMinutes: fields[7] as int,
      hoursDuration: fields[2] as int,
      minutesDuration: fields[3] as int,
      dateTimeSaved: fields[5] as DateTime,
    )
      ..items = (fields[8] as HiveList?)?.castHiveList()
      ..numberChips = (fields[9] as HiveList?)?.castHiveList();
  }

  @override
  void write(BinaryWriter writer, TimeSet obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.hoursDuration)
      ..writeByte(3)
      ..write(obj.minutesDuration)
      ..writeByte(5)
      ..write(obj.dateTimeSaved)
      ..writeByte(6)
      ..write(obj.startHours)
      ..writeByte(7)
      ..write(obj.startMinutes)
      ..writeByte(8)
      ..write(obj.items)
      ..writeByte(9)
      ..write(obj.numberChips);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimeSetInHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
