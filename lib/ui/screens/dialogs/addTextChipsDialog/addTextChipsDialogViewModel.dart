
import 'package:flutter/widgets.dart';
import 'package:timecalcprovider/services/text_chip_service.dart';

import '../../../../repository/text_choice_chip_data.dart';

class AddTextChipsDialogModel extends ChangeNotifier {

  final _textChipsService = TextChipsService();

  void saveNewTextChoiceChips(String value) {
    final newTextChip = TextChoiceChipData(
      label: value,
      isSelected: false,
      //selectedColor: Colors.blue,
      //textColor: Colors.white,
    );
    _textChipsService.addNewTextChip(newTextChip);
    notifyListeners();
  }
}