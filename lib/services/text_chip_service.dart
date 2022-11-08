

import 'package:hive/hive.dart';

import '../domain/data_provider/text_chips_data_provider.dart';
import '../repository/text_choice_chip_data.dart';

class TextChipsService {

  final _textChipsDataProvider = TextChipsDataProvider();

  Box<TextChoiceChipData> getTextChipsBox(){
    return _textChipsDataProvider.openedTextChipsBox;
  }

  Future<List<TextChoiceChipData>> getTextChoiceChips(){
    return _textChipsDataProvider.getTextChoiceChips();
  }

  Future<void> addNewTextChip(TextChoiceChipData newTextChip)async{
    await _textChipsDataProvider.addNewTextChip(newTextChip);
  }

  Future<void> deleteTextChipFromList(int index) async {
    _textChipsDataProvider.deleteTextChipFromList(index);
  }

}