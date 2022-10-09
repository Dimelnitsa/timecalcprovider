import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timecalcprovider/repository/counter_model.dart';
import '../../../repository/item.dart';
import '../../../repository/time_set.dart';
import '../../../services/item_service.dart';
import '../../../services/time_set_service.dart';
import '../dialogs_screen/numeral_item_dialog.dart';

class TimeSetModule with ChangeNotifier {

  final _timeSetService = TimeSetService();
  final _itemListService = ItemListService();

  var _timeSets = <TimeSet>[];
  List<TimeSet> get timeSets => _timeSets.toList();
  // late final Future<Box<TimeSet>> boxTimeSet;
  // late final Future<Box<Item>> boxOfItems;
  // late final Future<Box<NumberChipData>> boxNumberChips;

  //List<Item> get itemsTimeSet => _itemsTimeSet.toList();
  List<Item> _listOfItems = [];
  List<Item> get listOfItems => _listOfItems;
  bool _isFabVisible = true;
  // String? lastOpened = '';

  // List<NumberChipData> numberChips = [];

  TimeSetModule() {
    _setup();
  }

  ///Hive.
  Future<void> _setup() async {
    await _timeSetService.initializationTimeSet();
    _listOfItems = await _itemListService.loadListOfItems(_timeSetService.timeSet);
   await _loadListOfTimeSets();
    notifyListeners();
  }

  Future<void> _loadListOfTimeSets() async {
    _timeSets = await _timeSetService.loadListOfTimeSets();
    notifyListeners();
  }

  Future<void> loadTimeSet(String keyOfTimeSet)async{
    await _timeSetService.loadTimeSet(keyOfTimeSet);
    _listOfItems = await _itemListService.loadListOfItems(_timeSetService.timeSet);
    notifyListeners();
  }



  // Future<void> _readCurrentTimeSetFromHive() async {
  //   final pref = await SharedPreferences.getInstance();
  //   lastOpened = pref.getString('lastopened');
  //
  //   boxTimeSet = HiveManager.instance.openTimeSetBox();
  //   boxOfItems = HiveManager.instance.openItemsBox();
  //   boxNumberChips = HiveManager.instance.NumbersChoiceChipsBox();
  //
  //   if (lastOpened == null) {
  //     lastOpened = 'Новый';
  //     (await boxTimeSet).put(lastOpened, timeSet);
  //     final _savedListParts =
  //         _itemsTimeSet.map((item) => Item.clone(item)).toList();
  //     (await boxOfItems).addAll(_savedListParts);
  //     timeSet.addItems((await boxOfItems), _savedListParts);
  //
  //     (await boxNumberChips).addAll(numberChips);
  //     timeSet.addListNumberChips((await boxNumberChips), numberChips);
  //
  //     timeSet.save();
  //     (await boxOfItems).listenable().addListener(() {
  //       loadTimeSet(lastOpened!);
  //     });
  //   } else {
  //     await loadTimeSet(lastOpened!);
  //     (await boxOfItems).listenable().addListener(() {
  //       loadTimeSet(lastOpened!);
  //     });
  //   }
  // }

  // Future<void> loadTimeSet(String keyOfTimeSet) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   lastOpened = keyOfTimeSet;
  //   prefs.setString('lastopened', lastOpened!);
  //
  //   timeSet = (await boxTimeSet).get(keyOfTimeSet)!;
  //   _itemsTimeSet = timeSet.items as List<Item>;
  //   numberChips = timeSet.numberChips as List<NumberChipData>;
  //   notifyListeners();
  // }

  // Future<void> saveNewTimeSet(String title) async {
  //   final _savedTimeSet = TimeSet(
  //       title: title,
  //       startHours: timeSet.startHours,
  //       startMinutes: timeSet.startMinutes,
  //       hoursDuration: timeSet.hoursDuration,
  //       minutesDuration: timeSet.minutesDuration,
  //       dateTimeSaved: timeSet.dateTimeSaved);
  //
  //   (await boxTimeSet).put(title, _savedTimeSet);
  //
  //   final _savedListParts =
  //       _itemsTimeSet.map((item) => Item.clone(item)).toList();
  //   (await boxOfItems).addAll(_savedListParts);
  //   _savedTimeSet.addItems((await boxOfItems), _savedListParts);
  //
  //   final _savedListNumberChips = numberChips
  //       .map((numberChip) => NumberChipData.clone(numberChip))
  //       .toList();
  //   (await boxNumberChips).addAll(_savedListNumberChips);
  //   _savedTimeSet.addListNumberChips(
  //       (await boxNumberChips), _savedListNumberChips);
  //
  //   _savedTimeSet.save();
  //   await loadTimeSet(title);
  // }

  ///Calculation timeset's parameters
  TimeOfDay startSet() {
    return TimeOfDay.fromDateTime(_timeSetService.startTimeSet());
  }

  TimeOfDay finishSet() {
    return TimeOfDay.fromDateTime(_timeSetService.finishTimeSet());
  }

  String durationSet() {
    return _timeSetService.durationFormatHHMm();
  }

  String titleTimeSet() {
    return _timeSetService.timeSet.title;
  }


  Future<void> changeStartTime(BuildContext context) async {
    final startTime = TimeOfDay.fromDateTime(_timeSetService.startTimeSet());
    final TimeOfDay? newValue = await showTimePicker(
      context: context,
      initialTime: startTime,
    );
    if (newValue == null) {
      startTime;
    } else {
      _timeSetService.changeStartTimeSet(newValue);
    }
    notifyListeners();
  }

  Future<void> changeDuration(BuildContext context) async {
    final TimeOfDay? newValue = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 1, minute: 0),
    );
    _timeSetService.changeDuration(newValue);

    //   // if (lastOpened != '') {
    //   //   timeSet.save();
    //   // }

    notifyListeners();
  }

  Future<void> changeFinishTime(BuildContext context) async {
    final finishTime = TimeOfDay.fromDateTime(_timeSetService.finishTimeSet());
    TimeOfDay? newValue = await showTimePicker(
      context: context,
      initialTime: finishTime,
    );
    if (newValue == null) {
      print('нет результата');
    } else {
      final newFinish = DateTime(0,1,1, newValue.hour, newValue.minute);
      final condition = newFinish.isBefore(_timeSetService.startTimeSet());
      if (condition){
        showAlert(context);
      }
      else {
            _timeSetService.changeFinishTime(newValue);
            notifyListeners();
          }
      }

    }

  Future<void> showAlert(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Сохранить'),
        content: Text('Нельзя'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  }



  ///Items operations
  Future<void> showDialogAddNumeralItems(context) {
    return showDialog(
      context: context,
      builder: (context) {
        return const NumeralItemDialog();
      },
    );
  }

  void addTitle(Item item, String text) {
    item.titleItem = text;
    notifyListeners();
  }

  List<String>? titleChips(Item item) => item.chipsItem;

  void loadListTitleChips(Item item, List<String> listChips) {
    item.chipsItem?.clear();
    listChips.map((value) => item.chipsItem?.add(value));
    notifyListeners();
  }

  void addTitleChips(Item item, String value) {
    item.chipsItem?.add(value);
    //TODO сделать проверку по каждому элементу списка,
    // и если в chipsItem в первом элемменте есть совпадения - удалить этот item
    // listParts.map((item) => null);
    notifyListeners();
  }

  void removeTitleChips(Item item, String value) {
    item.chipsItem?.remove(value);
    notifyListeners();
  }

  void addListItems(int counter, int startNumber) {
    //   for (int i = 0; i < counter; i++) {
    //     addItem(i, startNumber);
    //     startNumber++;
    //   }
    //   notifyListeners();
  }

  void addItem(int index, int startNumber) async {
    //   Item item = Item(
    //       titleItem: '',
    //       chipsItem: <String>[startNumber.toString()],
    //       startTimeItemHours: 0,
    //       startTimeItemMinutes: 0,
    //       startTimeItemSeconds: 0,
    //       isVerse: false,
    //       isPicture: false,
    //       isTable: false);
    //  // await addNumberChipsInHive(startNumber);
    //  // (await boxOfItems).add(item);
    //  // timeSet.addItem((await boxOfItems), item);
    //  // timeSet.save();
    //  // _itemsTimeSet = timeSet.items as List<Item>;
    //   calculateAverageDurationOfItem(_itemsTimeSet.length);
    //   calculateStartTimeOfItems(_itemsTimeSet.length);
    //   notifyListeners();
  }

  // Future<void> addNumberChipsInHive(int startNumber) async {
  //   final numberChipData =
  //       NumberChipData(number: startNumber, isSelected: false);
  //   final _listNumberChipsInHive = (await boxNumberChips)
  //       .values
  //       .map((numberChip) => numberChip.number)
  //       .toList();
  //   if (!_listNumberChipsInHive.contains(startNumber)) {
  //     (await boxNumberChips).add(numberChipData);
  //     timeSet.addNumberChip((await boxNumberChips), numberChipData);
  //     timeSet.save();
  //     notifyListeners();
  //   }
  // }

  void addNewItem() {
    //   required String titleItem,
    //   required List<String> chipsItem,
    //   required bool isVerse,
    //   required bool isPicture,
    //   required bool isTable,
    // }) async {
    //   Item item = Item(
    //       titleItem: titleItem,
    //       chipsItem: chipsItem,
    //       startTimeItemHours: 0,
    //       startTimeItemMinutes: 0,
    //       startTimeItemSeconds: 0,
    //       isVerse: isVerse,
    //       isPicture: isPicture,
    //       isTable: isTable);
    //   // (await boxOfItems).add(item);
    //   // timeSet.addItem((await boxOfItems), item);
    //   // timeSet.save();
    //   // _itemsTimeSet = timeSet.items as List<Item>;
    //
    //   calculateAverageDurationOfItem(_itemsTimeSet.length);
    //   calculateStartTimeOfItems(_itemsTimeSet.length);
    //   notifyListeners();
  }

  void insertItemAbove(int itemIndex) async {
    //   Item item = Item(
    //       titleItem: '',
    //       chipsItem: [],
    //       startTimeItemHours: 0,
    //       startTimeItemMinutes: 0,
    //       startTimeItemSeconds: 0,
    //       isVerse: false,
    //       isPicture: false,
    //       isTable: false);
    //
    //  // (await boxOfItems).add(item);
    //   _itemsTimeSet.insert(itemIndex, item);
    //   // timeSet.save();
    //   calculateAverageDurationOfItem(_itemsTimeSet.length);
    //   calculateStartTimeOfItems(_itemsTimeSet.length);
    //   notifyListeners();
  }

  void insertItemUnder(int itemIndex) async {
    //   Item item = Item(
    //       titleItem: '',
    //       chipsItem: [],
    //       startTimeItemHours: 0,
    //       startTimeItemMinutes: 0,
    //       startTimeItemSeconds: 0,
    //       isVerse: false,
    //       isPicture: false,
    //       isTable: false);
    //
    //  // (await boxOfItems).add(item);
    //   _itemsTimeSet.insert(itemIndex + 1, item);
    //   // timeSet.save();
    //   calculateAverageDurationOfItem(_itemsTimeSet.length);
    //   calculateStartTimeOfItems(_itemsTimeSet.length);
    //   notifyListeners();
  }

  // void calculateStartTimeOfItems(int countOfItems) {
  //   //конвертация времени старта позиции в DateTime формат,
  //   //чтобы затем его преобразовать в TimeOfDay
  //   // DateTime startDateTimeOfItem = DateTime(
  //   //     0, 1, 1, startTimeOfSet(timeSet).hour, startTimeOfSet(timeSet).minute);
  //
  //   //calculateAverageDurationOfItem(_itemsTimeSet.length);
  //
  //   // расчет и присваивание времени старта каждой позиции из расчета средней продолжительности позиции
  //   for (int i = 0; i < countOfItems; i++) {
  //     final startTimeItem = TimeOfDay.fromDateTime(startDateTimeOfItem);
  //
  //     // if (lastOpened != '') {
  //     //   // если расчет делается не впервые
  //     //   if (timeSet.items != null) {
  //     //     timeSet.items![i].startTimeItemHours = startTimeItem.hour;
  //     //     timeSet.items![i].startTimeItemMinutes = startTimeItem.minute;
  //     //     timeSet.save();
  //     //     timeSet.items![i].save();
  //     //   }
  //     // } else {
  //     //   _itemsTimeSet[i].startTimeItemHours = startTimeItem.hour;
  //     //   _itemsTimeSet[i].startTimeItemMinutes = startTimeItem.minute;
  //     // }
  //     //вычисление и изменение времени старта следующего пункта
  //     final durationOfItemInMinutes = timeSet.items![i].durationInMinutes;
  //     final durationOfItemInSeconds = timeSet.items![i].durationInSeconds;
  //     final durationOfItem = Duration(minutes: durationOfItemInMinutes, seconds: durationOfItemInSeconds);
  //     //startDateTimeOfItem = startDateTimeOfItem.add(averageDurationOfItem);
  //     startDateTimeOfItem = startDateTimeOfItem.add(durationOfItem);
  //   }
  // }
  //
  // void calculateAverageDurationOfItem(int countOfItems) {
  //     final durationTimeSet = Duration(
  //         hours: timeSet.hoursDuration, minutes: timeSet.minutesDuration);
  //     double averageDurationOfItemInMinutes =
  //         durationTimeSet.inMinutes / countOfItems;
  //     int durationOfItemHours = (averageDurationOfItemInMinutes/60).floor();
  //     int durationOfItemMinutes = averageDurationOfItemInMinutes.floor();
  //     int durationOfItemSeconds =
  //         ((averageDurationOfItemInMinutes - durationOfItemMinutes) * 60)
  //             .round();
  //   saveAverageDurationOfItem(countOfItems,durationOfItemHours, durationOfItemMinutes, durationOfItemSeconds);
  // }
  //
  // void saveAverageDurationOfItem(int countOfItems, int durationOfItemHours, int durationOfItemMinutes,int durationOfItemSeconds ){
  //   for (int i = 0; i < countOfItems; i++) {
  //     // if (lastOpened != '') {
  //     //   // если расчет делается не впервые
  //     //   if (timeSet.items != null) {
  //     //     timeSet.items![i].durationHours = durationOfItemHours;
  //     //     timeSet.items![i].durationInMinutes = durationOfItemMinutes;
  //     //     timeSet.items![i].durationInSeconds = durationOfItemSeconds;
  //     //     timeSet.save();
  //     //     timeSet.items![i].save();
  //     //   }
  //     // } else {
  //     //   _itemsTimeSet[i].durationHours = durationOfItemHours;
  //     //   _itemsTimeSet[i].durationInMinutes = durationOfItemMinutes;
  //     //   _itemsTimeSet[i].durationInSeconds = durationOfItemSeconds;
  //     // }
  //   }
  // }

  void clearAllList(BuildContext context) async {
   // _itemsTimeSet.clear();
    // numberChips.clear();
    context.read<CounterModel>().startNumber = 1;
    // (await boxListOfItems).delete(timeSet.title);
    // (await boxListOfItems).put(timeSet.title, _listParts);
    notifyListeners();
  }

  void deleteTimeSet(String keyOfTimeSet) async {
    //   var _deleteTimeSet = (await boxTimeSet).get(keyOfTimeSet);
    //   _deleteTimeSet?.items?.deleteAllFromHive();
    //   (await boxOfItems).compact();
    //   _deleteTimeSet?.numberChips?.deleteAllFromHive();
    //   (await boxNumberChips).compact();
    //   _deleteTimeSet?.delete();
    //   (await boxTimeSet).compact();
  }

  void deleteItemFromList(int keyOfTimeSet) async {
    //   timeSet.items!.deleteFromHive(keyOfTimeSet);
    //   calculateAverageDurationOfItem(_itemsTimeSet.length);
    //   calculateStartTimeOfItems(_itemsTimeSet.length);
    //   notifyListeners();
  }

  void changeIsPicture(item) {
    item.isPicture = !item.isPicture;
    notifyListeners();
  }

  void changeIsVerse(item) {
    item.isVerse = !item.isVerse;
    notifyListeners();
  }

  void changeIsTable(item) {
    item.isTable = !item.isTable;
    notifyListeners();
  }

  bool get isFabVisible => _isFabVisible;

  void changeFabVisible(bool isVisible) {
    _isFabVisible = isVisible;
    notifyListeners();
  }

  void closeHive() async {
    await _timeSetService.closeHive();
    //HiveManager.instance.closeBox((await boxListOfItems));
  }
}
