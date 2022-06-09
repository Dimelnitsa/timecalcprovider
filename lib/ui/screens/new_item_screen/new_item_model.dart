import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:timecalcprovider/repository/item.dart';
import '../../../repository/text_choice_chip_data.dart';
import '../timeset_screen/timeset_model.dart';


class NewItemModel extends ChangeNotifier {
  Item? item;
  String titleItem = '';
  final itemChips = <String>[];
  List<TextChoiceChipData> textChoiceChips = [] ;
  var counter = 1;
  final List<int> numberChips = [];
  bool isVerse = false;
  bool isPicture = false;
  bool isTable = false;

  NewItemModel(){
    setupTextChoiceChips();
  }

  Future<void> setupTextChoiceChips()async{
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(TextChoiceChipDataAdapter());
    }
    var box = await Hive.openBox<TextChoiceChipData>('textChoiceChips');
    readTextChoiceChips(box);
    box.listenable().addListener(() {
      readTextChoiceChips(box);
    });
  }

  void readTextChoiceChips(Box<TextChoiceChipData> box){
    textChoiceChips = box.values.toList();
    notifyListeners();
  }


  Future<void> saveNewTextChoiceChips(String value) async{
    final newTextChip = TextChoiceChipData(
      label: value,
      isSelected: false,
      //selectedColor: Colors.blue,
      //textColor: Colors.white,
    );
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(TextChoiceChipDataAdapter());
    }
    var box = await Hive.openBox<TextChoiceChipData>('textChoiceChips');
    box.add(newTextChip);
    notifyListeners();
  }

  void selectChoiceChip (TextChoiceChipData choiceChip, bool isSelected ){
    choiceChip.isSelected = isSelected;
  notifyListeners();}

  void changeIsVerse (bool switchValue){
    isVerse = switchValue;
    notifyListeners();
  }

  void changeIsPicture (bool switchValue){
    isPicture = switchValue;
    notifyListeners();
  }

  void changeIsTable (bool switchValue){
    isTable = switchValue;
    notifyListeners();
  }

  void addItemChips(String value) {
    itemChips.add(value);
    notifyListeners();}

    void removeItemChips(value){
    itemChips.remove(value);
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

    notifyListeners();}

  void addNumberChips() {
    numberChips.add(counter ++);
    notifyListeners();}

  void saveItem (BuildContext context){
    context.read<TimeSetModule>().addNewItem(
        titleItem: titleItem,
        chipsItem: itemChips,
        isVerse: isVerse,
        isPicture: isPicture,
        isTable: isTable);

    Navigator.pop(context);
  }


}