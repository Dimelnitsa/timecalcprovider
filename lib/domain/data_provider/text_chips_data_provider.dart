import 'package:hive/hive.dart';
import '../../repository/text_choice_chip_data.dart';
import 'hive_manager.dart';

class TextChipsDataProvider {
  final Future<Box<TextChoiceChipData>> _textChipsBox = HiveManager.instance.TextChoiceChipsBox();
  Box<TextChoiceChipData> get openedTextChipsBox => Hive.box('textChoiceChips');

  TextChipsDataProvider() {
    initializeBoxTextChips();
  }

  Future<Box<TextChoiceChipData>> initializeBoxTextChips() {
    return HiveManager.instance.TextChoiceChipsBox();
  }

  Future<List<TextChoiceChipData>> getTextChoiceChips() async {
    return (await _textChipsBox).values.toList();
  }

  Future<void> addNewTextChip(TextChoiceChipData newTextChip) async{
    (await _textChipsBox).add(newTextChip);
  }

  Future<void> deleteTextChipFromList(int index) async {
    (await _textChipsBox).deleteAt(index);
  }
  
  
}
