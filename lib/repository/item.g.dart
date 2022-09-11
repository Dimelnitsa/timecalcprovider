// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ItemAdapter extends TypeAdapter<Item> {
  @override
  final int typeId = 2;

  @override
  Item read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Item(
      titleItem: fields[0] as String?,
      chipsItem: (fields[1] as List?)?.cast<String>(),
      startTimeItemHours: fields[4] as int,
      startTimeItemMinutes: fields[5] as int,
      startTimeItemSeconds: fields[10] as int,
      isPicture: fields[6] as bool,
      isVerse: fields[7] as bool,
      isTable: fields[8] as bool,
    )
      ..durationHours = fields[9] as int
      ..durationInMinutes = fields[2] as int
      ..durationInSeconds = fields[3] as int;
  }

  @override
  void write(BinaryWriter writer, Item obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.titleItem)
      ..writeByte(1)
      ..write(obj.chipsItem)
      ..writeByte(9)
      ..write(obj.durationHours)
      ..writeByte(2)
      ..write(obj.durationInMinutes)
      ..writeByte(3)
      ..write(obj.durationInSeconds)
      ..writeByte(4)
      ..write(obj.startTimeItemHours)
      ..writeByte(5)
      ..write(obj.startTimeItemMinutes)
      ..writeByte(10)
      ..write(obj.startTimeItemSeconds)
      ..writeByte(6)
      ..write(obj.isPicture)
      ..writeByte(7)
      ..write(obj.isVerse)
      ..writeByte(8)
      ..write(obj.isTable);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
