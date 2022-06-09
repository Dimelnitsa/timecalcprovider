// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text_choice_chip_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TextChoiceChipDataAdapter extends TypeAdapter<TextChoiceChipData> {
  @override
  final int typeId = 1;

  @override
  TextChoiceChipData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TextChoiceChipData(
      label: fields[0] as String,
      isSelected: fields[1] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, TextChoiceChipData obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.label)
      ..writeByte(1)
      ..write(obj.isSelected);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TextChoiceChipDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
