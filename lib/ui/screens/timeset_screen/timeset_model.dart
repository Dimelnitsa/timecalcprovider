import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timecalcprovider/domain/data_provider/hive_manager.dart';
import 'package:timecalcprovider/repository/counter_model.dart';
import 'package:timecalcprovider/repository/number_chips_data.dart';
import '../../../repository/item.dart';
import '../../../repository/timeset_in_hive.dart';
import '../dialogs_screen/numeral_item_dialog.dart';

class TimeSetModule with ChangeNotifier {
  var timeSet = TimeSetInHive(
      title: 'Новый',
      startHours: TimeOfDay.now().hour.toInt(),
      startMinutes: TimeOfDay.now().minute.toInt(),
      dateTimeSaved: DateTime.now());

  late final Future<Box<TimeSetInHive>> boxTimeSet;
  late final Future<Box<Item>> boxOfItems;
  late final Future<Box<NumberChipData>> boxNumberChips;
  List<Item> _itemsTimeSet = [];
  List<Item> get itemsTimeSet => _itemsTimeSet.toList();

  bool _isFabVisible = true;
  String? lastOpened = '';

  List<NumberChipData> numberChips = [];

  TimeOfDay startTimeOfSet(TimeSetInHive timeSetInHive) => TimeOfDay(
      hour: timeSetInHive.startHours, minute: timeSetInHive.startMinutes);

  TimeSetModule() {
    _setup();
  }

  ///Hive.
  Future<void> _setup() async {
    await _readCurrentTimeSetFromHive();
  }

  Future<void> _readCurrentTimeSetFromHive() async {
    final pref = await SharedPreferences.getInstance();
    lastOpened = pref.getString('lastopened');

    boxTimeSet = HiveManager.instance.openTimeSetBox();
    boxOfItems = HiveManager.instance.openItemsBox();
    boxNumberChips = HiveManager.instance.NumbersChoiceChipsBox();

    if (lastOpened == null) {
      lastOpened = 'Новый';
      (await boxTimeSet).put(lastOpened, timeSet);
      final _savedListParts =
          _itemsTimeSet.map((item) => Item.clone(item)).toList();
      (await boxOfItems).addAll(_savedListParts);
      timeSet.addItems((await boxOfItems), _savedListParts);

      (await boxNumberChips).addAll(numberChips);
      timeSet.addListNumberChips((await boxNumberChips), numberChips);

      timeSet.save();
      (await boxOfItems).listenable().addListener(() {
        loadTimeSet(lastOpened!);
      });
    } else {
      await loadTimeSet(lastOpened!);
      (await boxOfItems).listenable().addListener(() {
        loadTimeSet(lastOpened!);
      });
    }
  }

  Future<void> loadTimeSet(String keyOfTimeSet) async {
    final prefs = await SharedPreferences.getInstance();
    lastOpened = keyOfTimeSet;
    prefs.setString('lastopened', lastOpened!);

    timeSet = (await boxTimeSet).get(keyOfTimeSet)!;
    _itemsTimeSet = timeSet.items as List<Item>;
    numberChips = timeSet.numberChips as List<NumberChipData>;
    notifyListeners();
  }

  Future<void> saveNewTimeSet(String title) async {
    final _savedTimeSet = TimeSetInHive(
        title: title,
        startHours: timeSet.startHours,
        startMinutes: timeSet.startMinutes,
        hoursDuration: timeSet.hoursDuration,
        minutesDuration: timeSet.minutesDuration,
        dateTimeSaved: timeSet.dateTimeSaved);

    (await boxTimeSet).put(title, _savedTimeSet);

    final _savedListParts =
        _itemsTimeSet.map((item) => Item.clone(item)).toList();
    (await boxOfItems).addAll(_savedListParts);
    _savedTimeSet.addItems((await boxOfItems), _savedListParts);

    final _savedListNumberChips = numberChips
        .map((numberChip) => NumberChipData.clone(numberChip))
        .toList();
    (await boxNumberChips).addAll(_savedListNumberChips);
    _savedTimeSet.addListNumberChips(
        (await boxNumberChips), _savedListNumberChips);

    _savedTimeSet.save();
    await loadTimeSet(title);
  }

  ///Calculation timeset's parameters
  TimeOfDay finishTime() {
    final finishHour = startTimeOfSet(timeSet).hour + timeSet.hoursDuration;
    final finishMinutes =
        startTimeOfSet(timeSet).minute + timeSet.minutesDuration;
    final finish = startTimeOfSet(timeSet)
        .replacing(hour: finishHour, minute: finishMinutes);
    return finish;
  }

  String durationTimeSet() {
    DateTime _startInDateTime = DateTime(
        0, 1, 1, startTimeOfSet(timeSet).hour, startTimeOfSet(timeSet).minute);
    DateTime _finishInDateTime =
        DateTime(0, 1, 1, finishTime().hour, finishTime().minute);

    final _durationOfTimeSetInMinutes =
        _finishInDateTime.difference(_startInDateTime).inMinutes;

    final _durationInHourFormat = _durationOfTimeSetInMinutes ~/ 60;
    final _durationInMinutesFormat =
        _durationOfTimeSetInMinutes - (_durationInHourFormat * 60).round();

    return '$_durationInHourFormat:$_durationInMinutesFormat';
  }

  Future<void> changeStartTime(BuildContext context) async {
    final TimeOfDay? newValue = await showTimePicker(
      context: context,
      initialTime: startTimeOfSet(timeSet),
    );
    if (newValue == null) {
      startTimeOfSet(timeSet);
    } else {
      timeSet.startHours = newValue.hour;
      timeSet.startMinutes = newValue.minute;
      timeSet.save();
    }
    calculateStartTimeOfItems(_itemsTimeSet.length);
    notifyListeners();
  }

  Future<void> changeDuration(BuildContext context) async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 1, minute: 0),
    );
    newTime == null
        ? timeSet.hoursDuration = 1
        : timeSet.hoursDuration = newTime.hour;
    newTime == null
        ? timeSet.minutesDuration = 0
        : timeSet.minutesDuration = newTime.minute;

    if (lastOpened != '') {
      timeSet.save();
    }
    calculateStartTimeOfItems(_itemsTimeSet.length);
    notifyListeners();
  }

  Future<void> changeFinishTime(BuildContext context) async {
    TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: finishTime(),
    );
    if (newTime == null) {
      // значение hoursDuration  minutesDuration определяются исходя из предыдущей finishTime
      timeSet.hoursDuration = finishTime().hour - startTimeOfSet(timeSet).hour;
      timeSet.minutesDuration =
          finishTime().minute - startTimeOfSet(timeSet).minute;
    } else {
      // hoursDuration  minutesDuration определяются исходя из нового finishTime
      timeSet.hoursDuration = newTime.hour - startTimeOfSet(timeSet).hour;
      timeSet.minutesDuration = newTime.minute - startTimeOfSet(timeSet).minute;
    }
    if (lastOpened != '') {
      timeSet.save();
    }
    calculateStartTimeOfItems(_itemsTimeSet.length);
    notifyListeners();
  }

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
    for (int i = 0; i < counter; i++) {
      addItem(i, startNumber);
      startNumber++;
    }
    notifyListeners();
  }

  void addItem(int index, int startNumber) async {
    Item item = Item(
        titleItem: '',
        chipsItem: <String>[startNumber.toString()],
        startTimeItemHours: 0,
        startTimeItemMinutes: 0,
        isVerse: false,
        isPicture: false,
        isTable: false);
    await addNumberChipsInHive(startNumber);
    (await boxOfItems).add(item);
    timeSet.addItem((await boxOfItems), item);
    timeSet.save();
    _itemsTimeSet = timeSet.items as List<Item>;
    calculateAverageDurationOfItem(_itemsTimeSet.length);
    calculateStartTimeOfItems(_itemsTimeSet.length);
    notifyListeners();
  }

  Future<void> addNumberChipsInHive(int startNumber) async {
    final numberChipData =
        NumberChipData(number: startNumber, isSelected: false);
    final _listNumberChipsInHive = (await boxNumberChips)
        .values
        .map((numberChip) => numberChip.number)
        .toList();
    if (!_listNumberChipsInHive.contains(startNumber)) {
      (await boxNumberChips).add(numberChipData);
      timeSet.addNumberChip((await boxNumberChips), numberChipData);
      timeSet.save();
      notifyListeners();
    }
  }

  void addNewItem({
    required String titleItem,
    required List<String> chipsItem,
    required bool isVerse,
    required bool isPicture,
    required bool isTable,
  }) async {
    Item item = Item(
        titleItem: titleItem,
        chipsItem: chipsItem,
        startTimeItemHours: 0,
        startTimeItemMinutes: 0,
        isVerse: isVerse,
        isPicture: isPicture,
        isTable: isTable);
    (await boxOfItems).add(item);
    timeSet.addItem((await boxOfItems), item);
    timeSet.save();
    _itemsTimeSet = timeSet.items as List<Item>;

    calculateAverageDurationOfItem(_itemsTimeSet.length);
    calculateStartTimeOfItems(_itemsTimeSet.length);
    notifyListeners();
  }

  void insertItemAbove(int itemIndex) async {
    Item item = Item(
        titleItem: '',
        chipsItem: [],
        startTimeItemHours: 0,
        startTimeItemMinutes: 0,
        isVerse: false,
        isPicture: false,
        isTable: false);

    (await boxOfItems).add(item);
    _itemsTimeSet.insert(itemIndex, item);
    timeSet.save();
    calculateAverageDurationOfItem(_itemsTimeSet.length);
    calculateStartTimeOfItems(_itemsTimeSet.length);
    notifyListeners();
  }

  void insertItemUnder(int itemIndex) async {
    Item item = Item(
        titleItem: '',
        chipsItem: [],
        startTimeItemHours: 0,
        startTimeItemMinutes: 0,
        isVerse: false,
        isPicture: false,
        isTable: false);

    (await boxOfItems).add(item);
    _itemsTimeSet.insert(itemIndex + 1, item);
    timeSet.save();
    calculateAverageDurationOfItem(_itemsTimeSet.length);
    calculateStartTimeOfItems(_itemsTimeSet.length);
    notifyListeners();
  }

  void calculateStartTimeOfItems(int countOfItems) {
    //конвертация времени старта позиции в DateTime формат,
    //чтобы затем его преобразовать в TimeOfDay
    DateTime startDateTimeOfItem = DateTime(
        0, 1, 1, startTimeOfSet(timeSet).hour, startTimeOfSet(timeSet).minute);

    //calculateAverageDurationOfItem(_itemsTimeSet.length);

    // расчет и присваивание времени старта каждой позиции из расчета средней продолжительности позиции
    for (int i = 0; i < countOfItems; i++) {
      final startTimeItem = TimeOfDay.fromDateTime(startDateTimeOfItem);

      if (lastOpened != '') {
        // если расчет делается не впервые
        if (timeSet.items != null) {
          timeSet.items![i].startTimeItemHours = startTimeItem.hour;
          timeSet.items![i].startTimeItemMinutes = startTimeItem.minute;
          timeSet.save();
          timeSet.items![i].save();
        }
      } else {
        _itemsTimeSet[i].startTimeItemHours = startTimeItem.hour;
        _itemsTimeSet[i].startTimeItemMinutes = startTimeItem.minute;
      }
      //вычисление и изменение времени старта следующего пункта
      final durationOfItemInMinutes = timeSet.items![i].durationInMinutes;
      final durationOfItemInSeconds = timeSet.items![i].durationInSeconds;
      final durationOfItem = Duration(minutes: durationOfItemInMinutes, seconds: durationOfItemInSeconds);
      //startDateTimeOfItem = startDateTimeOfItem.add(averageDurationOfItem);
      startDateTimeOfItem = startDateTimeOfItem.add(durationOfItem);
    }
  }

  void calculateAverageDurationOfItem(int countOfItems) {
      final durationTimeSet = Duration(
          hours: timeSet.hoursDuration, minutes: timeSet.minutesDuration);
      double averageDurationOfItemInMinutes =
          durationTimeSet.inMinutes / countOfItems;
      int durationOfItemMinutes = averageDurationOfItemInMinutes.floor();
      int durationOfItemSeconds =
          ((averageDurationOfItemInMinutes - durationOfItemMinutes) * 60)
              .round();
    saveAverageDurationOfItem(countOfItems, durationOfItemMinutes, durationOfItemSeconds);
  }

  void saveAverageDurationOfItem(int countOfItems, int durationOfItemMinutes,int durationOfItemSeconds ){
    for (int i = 0; i < countOfItems; i++) {
      if (lastOpened != '') {
        // если расчет делается не впервые
        if (timeSet.items != null) {
          timeSet.items![i].durationInMinutes = durationOfItemMinutes;
          timeSet.items![i].durationInSeconds = durationOfItemSeconds;
          timeSet.save();
          timeSet.items![i].save();
        }
      } else {
        _itemsTimeSet[i].durationInMinutes = durationOfItemMinutes;
        _itemsTimeSet[i].durationInSeconds = durationOfItemSeconds;
      }
    }
  }


  void clearAllList(BuildContext context) async {
    _itemsTimeSet.clear();
    numberChips.clear();
    context.read<CounterModel>().startNumber = 1;
    // (await boxListOfItems).delete(timeSet.title);
    // (await boxListOfItems).put(timeSet.title, _listParts);
    notifyListeners();
  }

  void deleteTimeSet(String keyOfTimeSet) async {
    var _deleteTimeSet = (await boxTimeSet).get(keyOfTimeSet);
    _deleteTimeSet?.items?.deleteAllFromHive();
    (await boxOfItems).compact();
    _deleteTimeSet?.numberChips?.deleteAllFromHive();
    (await boxNumberChips).compact();
    _deleteTimeSet?.delete();
    (await boxTimeSet).compact();
  }

  void deleteItemFromList(int keyOfTimeSet) async {
    timeSet.items!.deleteFromHive(keyOfTimeSet);
    calculateAverageDurationOfItem(_itemsTimeSet.length);
    calculateStartTimeOfItems(_itemsTimeSet.length);
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
    HiveManager.instance.closeBox((await boxTimeSet));
    //HiveManager.instance.closeBox((await boxListOfItems));
  }
}
