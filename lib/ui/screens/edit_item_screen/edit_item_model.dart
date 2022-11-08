import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:timecalcprovider/ui/screens/timeset_screen/time_set_model.dart';
import '../../../repository/item.dart';
import '../../../repository/text_choice_chip_data.dart';
import '../../../services/text_chip_service.dart';

class EditItemModel extends ChangeNotifier {

  final _textChipsService = TextChipsService();
  Item itemEdited;
  String? titleItem;
  bool isVerse = false;
  bool isPicture = false;
  bool isTable = false;

  List<String>? itemChips = <String>[];
  List<TextChoiceChipData> textChoiceChips = [];

  late final Box<TextChoiceChipData> textChipsBox;
  ValueListenable<Object>? _listenable;

  var counter = 1;


  EditItemModel({required this.itemEdited}) {
    titleItem = itemEdited.titleItem;
    itemChips = itemEdited.chipsItem;
    isVerse = itemEdited.isVerse;
    isPicture = itemEdited.isPicture;
    isTable = itemEdited.isTable;
    _initialization();
    //setupChoiceChips();
  }

  Future<void> _initialization()async {
    await getTextChoiceChips();
    textChipsBox = _textChipsService.getTextChipsBox();
    _listenable = textChipsBox.listenable();
    _listenable?.addListener(getTextChoiceChips);

    // textChipsBox.listenable().addListener(() {
    //   getTextChoiceChips();
    //     });
   // timeSet = await _timeSetService.timeSet;
    notifyListeners();
  }

  Future<void> getTextChoiceChips()async{
    textChoiceChips = await _textChipsService.getTextChoiceChips();
    notifyListeners();
  }

  // Future<void> setupChoiceChips() async {
  //   //textChipsBox = await HiveManager.instance.TextChoiceChipsBox();
  //   notifyListeners();
  //   //getTextChoiceChips();
  //   //textChipsBox.listenable().addListener(() {
  //     getTextChoiceChips();
  //   });
  // }

  // void getTextChoiceChips() async {
  //   textChoiceChips = textChipsBox.values.toList();
  //   notifyListeners();
  // }

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

  void deleteItemChips(
      // TextChoiceChipData textChoiceChipData,
       int index){
    //textChoiceChips.remove(textChoiceChipData);
    _textChipsService.deleteTextChipFromList(index);
    notifyListeners();
  }

  // void addTextChoiceChips(String value) {
  //   final newTextChip = TextChoiceChipData(
  //     label: value,
  //     isSelected: false,
  //     //selectedColor: Colors.blue,
  //     // textColor: Colors.white,
  //   );
  //   textChoiceChips.add(newTextChip);
  //   notifyListeners();
  // }

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
    context.read<TimeSetModule>().saveChangesOfItem(itemEdited);
  }

  @override
  void dispose() {
    _listenable?.removeListener(getTextChoiceChips);
    super.dispose();
  }
}
