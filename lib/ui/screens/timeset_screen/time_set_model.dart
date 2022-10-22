import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../services/num_chips_service.dart';
import '../../../services/session_service.dart';
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

  List<TimeSet> _timeSetsList = [];
  List<TimeSet> get listOfTimeSets => _timeSetsList.toList();

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
    _timeSetsList = await _timeSetService.loadListOfTimeSets();

    if (_lastSession == null) {
      _lastSession = 'Новый';
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
    _listOfItems = _itemListService.getListOfItems(_timeSet);
    _numberChips = await _numChipsService.getListOfNumberChips(_timeSet);
    notifyListeners();
  }

  Future<void> saveNewTimeSetAs(String title) async {
    ///1. save  Time Set in Hive
    await _timeSetService.saveNewTimeSet(title);
    _timeSet = await _timeSetService.loadTimeSet(title);
    _timeSetsList = await _timeSetService.loadListOfTimeSets();

    ///2. save listItems as HiveList of Time Set in Hive
    await _itemListService.saveListOfItemsForNewTimeSet(_timeSet, _listOfItems);

    ///4, save list of NumberChips in Hive
    await _numChipsService.saveListOfNumberChips(_timeSet);

    ///6. save savedTimeSet
    _timeSetService.saveChangesTimeSet();

    ///7. open saved Time Set as current
    await loadTimeSet(title);
    // _itemListService.changeDurationOfItems(_timeSet);
    // _itemListService.calculateStartTimeInListItems(timeSet: timeSet);
    _itemListService.updateListItems(timeSet);
    notifyListeners();
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
      //_itemListService.calculateStartTimeInListItems(timeSet: timeSet);
      _itemListService.updateListItems(timeSet);
    }
    notifyListeners();
  }

  Future<void> changeDuration(BuildContext context) async {
    final TimeOfDay? newValue = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 1, minute: 0),
    );
    _timeSetService.changeDuration(newValue);
    //пересчет продолжительности item
    // _itemListService.changeDurationOfItems(_timeSet);
    // _itemListService.calculateStartTimeInListItems(timeSet: timeSet);
    _itemListService.updateListItems(timeSet);
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
        // _itemListService.changeDurationOfItems(_timeSet);
        // _itemListService.calculateStartTimeOfItems(_timeSet.startHours, _timeSet.startMinutes);
        // _itemListService.changeDurationOfItems(_timeSet);
        // _itemListService.calculateStartTimeInListItems(timeSet: timeSet);
        _itemListService.updateListItems(timeSet);
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

  void addItemsInList(int counter, int startNumber) {
    _itemListService.addListItems(counter, startNumber, _timeSet);
    notifyListeners();
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

  void addNewItem({
    required String titleItem,
    required List<String> chipsItem,
    //required int startTimeItemHours,
    //required int startTimeItemMinutes,
    // required int startTimeItemSeconds,
    required bool isVerse,
    required bool isPicture,
    required bool isTable,
  }) async {
    Item item = Item(
        titleItem: titleItem,
        chipsItem: chipsItem,
        startTimeItemHours: 0, //startTimeItemHours,
        startTimeItemMinutes: 0, //startTimeItemMinutes,
        startTimeItemSeconds: 0, //startTimeItemSeconds,
        isVerse: isVerse,
        isPicture: isPicture,
        isTable: isTable);

    _itemListService.addItemInListTimeSet(_timeSet, item);
    notifyListeners();
  }

  void insertItemAbove(int itemIndex) async {
    Item item = Item(
        titleItem: '',
        chipsItem: [],
        startTimeItemHours: 0,
        startTimeItemMinutes: 0,
        startTimeItemSeconds: 0,
        isVerse: false,
        isPicture: false,
        isTable: false);
    _itemListService.addItemInTimeSet(
        timeSet, item); // (await boxOfItems).add(item);
    _itemListService.insertItem(timeSet, item, itemIndex);
    _timeSetService.saveChangesTimeSet();
    //_itemListService.updateListItems(timeSet);
    notifyListeners();
  }

  void insertItemUnder(int itemIndex) async {
    Item item = Item(
        titleItem: '',
        chipsItem: [],
        startTimeItemHours: 0,
        startTimeItemMinutes: 0,
        startTimeItemSeconds: 0,
        isVerse: false,
        isPicture: false,
        isTable: false);
    _itemListService.addItemInTimeSet(
        timeSet, item); // (await boxOfItems).add(item);
    _itemListService.insertItem(timeSet, item, itemIndex + 1);
    _timeSetService.saveChangesTimeSet();
    _itemListService.updateListItems(timeSet);
    notifyListeners();
  }

  void clearAllList(BuildContext context) async {
    _itemListService.deleteListOfItems(timeSet);
    _numChipsService.deleteListOfNumberChips(timeSet);
    context.read<CounterModel>().startNumber = 1;
    notifyListeners();
  }

  void deleteTimeSet(String keyOfTimeSet) async {
    var _deleteTimeSet = await _timeSetService
        .loadTimeSet(keyOfTimeSet); //(await boxTimeSet).get(keyOfTimeSet);
    _itemListService.deleteListOfItems(
        _deleteTimeSet); //  _deleteTimeSet?.items?.deleteAllFromHive();
    //   _deleteTimeSet?.numberChips?.deleteAllFromHive();
    //   (await boxNumberChips).compact();
    await _timeSetService
        .deleteTimeSet(_deleteTimeSet); //   _deleteTimeSet?.delete();
    _timeSetsList = await _timeSetService.loadListOfTimeSets();
    notifyListeners();
  }

  void deleteItemFromList(int keyOfTimeSet) async {
    _itemListService.deleteItemFromList(timeSet, keyOfTimeSet);
    _itemListService.updateListItems(timeSet);
    notifyListeners();
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
    await _timeSetService.closeTimeSetHiveBox();
    await _itemListService.closeTimeSetHiveBox();
    await _numChipsService.closeBoxOfNumberChips();
  }
}
