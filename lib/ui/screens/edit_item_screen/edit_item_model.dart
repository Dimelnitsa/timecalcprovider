import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:timecalcprovider/domain/data_provider/hive_manager.dart';
import 'package:timecalcprovider/repository/number_chips_data.dart';
import 'package:timecalcprovider/repository/timeset.dart';
import '../../../repository/item.dart';
import '../../../repository/text_choice_chip_data.dart';

class EditItemModel extends ChangeNotifier {
  Item itemEdited;
  TimeSet timeSet;
  String? titleItem;
  bool isVerse = false;
  bool isPicture = false;
  bool isTable = false;

  List<String>? itemChips = <String>[];
  List<TextChoiceChipData> textChoiceChips = [];
  late final Box<TextChoiceChipData> textChipsBox;

  var counter = 1;
  List<NumberChipData> numberChips = [];
  late final Box<NumberChipData> numberChipsBox;

  EditItemModel({required this.itemEdited, required this.timeSet}) {
    titleItem = itemEdited.titleItem;
    itemChips = itemEdited.chipsItem;
    isVerse = itemEdited.isVerse;
    isPicture = itemEdited.isPicture;
    isTable = itemEdited.isTable;

    setupChoiceChips();
  }

  Future<void> setupChoiceChips() async {
    textChipsBox = await HiveManager.instance.TextChoiceChipsBox();
    numberChipsBox = await HiveManager.instance.NumbersChoiceChipsBox();

    readTextChoiceChips();
    textChipsBox.listenable().addListener(() {
      readTextChoiceChips();
    });
    numberChipsBox.listenable().addListener(() {
      readTextChoiceChips();
    });
  }

  void readTextChoiceChips() {
    textChoiceChips = textChipsBox.values.toList();
    numberChips = timeSet.numberChips as List<NumberChipData>;
    notifyListeners();
  }

  Future<void> saveNewTextChoiceChips(String value) async {
    final newTextChip = TextChoiceChipData(
      label: value,
      isSelected: false,
      //selectedColor: Colors.blue,
      //textColor: Colors.white,
    );
    textChipsBox.add(newTextChip);
    notifyListeners();
  }

  void selectChoiceChip(TextChoiceChipData choiceChip, bool isSelected) {
    choiceChip.isSelected = isSelected;
    notifyListeners();
  }

  void changeTitle(String newTitle) {
    titleItem = newTitle;
    notifyListeners();
  }

  void changeIsVerse(bool switchValue) {
    isVerse = switchValue;
    notifyListeners();
  }

  void changeIsPicture(bool switchValue) {
    isPicture = switchValue;
    notifyListeners();
  }

  void changeIsTable(bool switchValue) {
    isTable = switchValue;
    notifyListeners();
  }

  void addItemChips(String value) {
    itemChips?.add(value);
    notifyListeners();
  }

  void removeItemChips(value) {
    itemChips?.remove(value);
    notifyListeners();
  }

  void addTextChoiceChips(String value) {
    final newTextChip = TextChoiceChipData(
      label: value,
      isSelected: false,
      //selectedColor: Colors.blue,
      // textColor: Colors.white,
    );
    textChoiceChips.add(newTextChip);
    notifyListeners();
  }

  void addNumberChips() {
    //numberChips.add(counter++);
    notifyListeners();
  }

  void saveItem(BuildContext context) {
    itemEdited.titleItem = titleItem;
    itemEdited.chipsItem = itemChips;
    itemEdited.isVerse = isVerse;
    itemEdited.isPicture = isPicture;
    itemEdited.isTable = isTable;
    itemEdited.save();
    notifyListeners();
    Navigator.pop(context);
  }

}
