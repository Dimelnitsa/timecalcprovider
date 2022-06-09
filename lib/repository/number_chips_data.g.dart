// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'number_chips_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NumberChipDataAdapter extends TypeAdapter<NumberChipData> {
  @override
  final int typeId = 3;

  @override
  NumberChipData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NumberChipData(
      number: fields[0] as int,
      isSelected: fields[1] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, NumberChipData obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.number)
      ..writeByte(1)
      ..write(obj.isSelected);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NumberChipDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
