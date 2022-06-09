
import 'package:hive/hive.dart';
part 'text_choice_chip_data.g.dart';

@HiveType(typeId: 1)
class TextChoiceChipData {
  @HiveField(0)
  final String label;
  
  @HiveField(1)
  bool isSelected;
  
  // @HiveField(2)
  // Color textColor;
  //
  // @HiveField(3)
  // Color selectedColor;

  TextChoiceChipData({
    required this.label,
    required this.isSelected,
    // required this.textColor,
    // required this.selectedColor,
  });

  TextChoiceChipData copy({
    String? label,
    bool? isSelected,
    // Color? textColor,
    // Color? selectedColor,
  }) =>
      TextChoiceChipData(
        label: label ?? this.label,
        isSelected: isSelected ?? this.isSelected,
        // textColor: textColor ?? this.textColor,
        // selectedColor: selectedColor ?? this.selectedColor,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is TextChoiceChipData &&
              runtimeType == other.runtimeType &&
              label == other.label &&
              isSelected == other.isSelected ;
              // textColor == other.textColor &&
              // selectedColor == other.selectedColor;

  @override
  int get hashCode =>
      label.hashCode ^
      isSelected.hashCode ;
      // textColor.hashCode ^
      // selectedColor.hashCode;
}