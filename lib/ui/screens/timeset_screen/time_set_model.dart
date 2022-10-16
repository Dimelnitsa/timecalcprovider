import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timecalcprovider/services/num_chips_service.dart';
import 'package:timecalcprovider/services/session_service.dart';
import '../../../repository/counter_model.dart';
import '../../../repository/item.dart';
import '../../../repository/number_chips_data.dart';
import '../../../repository/time_set.dart';
import '../../../services/item_list_service.dart';
import '../../../services/time_set_service.dart';
import '../dialogs_screen/numeral_item_dialog.dart';

class TimeSetModule with ChangeNotifier {
  final _timeSetService = TimeSetService();
  var _timeSet;
  TimeSet get timeSet => _timeSet;

  List<TimeSet> _listOfTimeSets = [];
  List<TimeSet> get listOfTimeSets => _listOfTimeSets.toList();

  final _itemListService = ItemListService();
  List<Item> _listOfItems = [];
  List<Item> get listOfItems => _listOfItems;

  final _numChipsService = NumChipsService();
  List<NumberChipData> _numberChips = [];
  List<NumberChipData> get numberChips => _numberChips;


  String? _lastSession;
  final _sessionService = SessionService();


  bool _isFabVisible = true;

  TimeSetModule() {
    _initializationTimeSet();
  }

  Future<void> _initializationTimeSet() async {
    _lastSession = await _sessionService.getLastSession();
    _listOfTimeSets = await _timeSetService.loadListOfTimeSets();
    if (_lastSession == null){
      _lastSession = 'Новый';
      print(_lastSession);
      loadTimeSet(_lastSession!);
      _sessionService.saveLastSession(_lastSession!);
      notifyListeners();
      await saveNewTimeSetAs(_lastSession!);
    } else {

      loadTimeSet(_lastSession!);
      notifyListeners();
    }

  }

  Future<void> loadTimeSet(String keyOfTimeSet) async {
    _timeSet = await _timeSetService.loadTimeSet(keyOfTimeSet);
    _listOfItems =
        await _itemListService.getListOfItems(_timeSet);
    _numberChips =
        await _numChipsService.getListOfNumberChips(_timeSet);
    notifyListeners();
  }

  Future<void> saveNewTimeSetAs(String title) async {
    ///1. save  Time Set in Hive
   await _timeSetService.saveNewTimeSet(title);
   _timeSet = await _timeSetService.loadTimeSet(title);
   _listOfTimeSets = await _timeSetService.loadListOfTimeSets();
    ///2. save listItems as HiveList of Time Set in Hive
  await _itemListService.saveListOfItems(_timeSet);
    ///4, save list of NumberChips in Hive
   await _numChipsService.saveListOfNumberChips(_timeSet);
    ///6. save savedTimeSet
    await _timeSetService.saveChangesTimeSet();
    ///7. open saved Time Set as current
     await loadTimeSet(title);
  }

  ///Calculation time_set's parameters
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
      _itemListService.calculateStartTimeOfItems(_timeSetService.timeSet);
    }
    notifyListeners();
  }

  Future<void> changeDuration(BuildContext context) async {
    final TimeOfDay? newValue = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 1, minute: 0),
    );
    _timeSetService.changeDuration(newValue);
    _itemListService.changeDurationOfItems(_timeSet);
    _itemListService.calculateStartTimeOfItems(_timeSet);
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
      final newFinish = DateTime(0, 1, 1, newValue.hour, newValue.minute);
      final condition = newFinish.isBefore(_timeSetService.startTimeSet());
      if (condition) {
        showAlert(context);
      } else {
        _timeSetService.changeFinishTime(newValue);
        _itemListService.changeDurationOfItems(_timeSet);
        _itemListService.calculateStartTimeOfItems(_timeSet);
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
