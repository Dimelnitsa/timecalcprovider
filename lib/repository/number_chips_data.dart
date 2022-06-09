import 'package:hive/hive.dart';
part 'number_chips_data.g.dart';

@HiveType(typeId: 3)
class NumberChipData extends HiveObject{
  @HiveField(0)
  final int number;

  @HiveField(1)
  bool isSelected;

  NumberChipData({ required this.number, required this.isSelected});

  factory NumberChipData.clone(NumberChipData numberChipData) {
    return NumberChipData(
      number: numberChipData.number,
      isSelected: numberChipData.isSelected,
    );
  }

  NumberChipData copy({
    int? number,
    bool? isSelected,
    // Color? textColor,
    // Color? selectedColor,
  }) =>
      NumberChipData(
        number: number ?? this.number,
        isSelected: isSelected ?? this.isSelected,
        // textColor: textColor ?? this.textColor,
        // selectedColor: selectedColor ?? this.selectedColor,
      );
}
