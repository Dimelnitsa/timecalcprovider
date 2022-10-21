
import '../domain/data_provider/items_data_provider.dart';
import '../repository/item.dart';
import '../repository/time_set.dart';
import 'time_set_calculator.dart';

class ItemListService {
  final _itemsDataProvider = ItemsDataProvider();
  TimeSetCalculator _timeSetCalculator = TimeSetCalculator();

  // List<Item> _items = [];
  // List<Item> get items => _items;
  DateTime _averageDurationOfItem = DateTime(0, 1, 1, 1, 0, 0);

  List<Item> getListOfItems(TimeSet timeSet) {
    if ((_itemsDataProvider.loadItemsFromHive(timeSet)) == null) {
      //return _items;
      return [];
    } else {
      return (_itemsDataProvider.loadItemsFromHive(timeSet))!;
      //_items = (_itemsDataProvider.loadItemsFromHive(timeSet))!;
      // return _items;
    }
  }

  /// calculation start time of items
  void calculateStartTimeInListItems(
      {required TimeSet timeSet})  {
    DateTime startTimeOfItem = DateTime(0, 1, 1, timeSet.startHours, timeSet.startMinutes, 0);
    timeSet.items?.forEach((item) {
      _timeSetCalculator.setItemStartTime(item: item, startTime: startTimeOfItem);
      startTimeOfItem = _timeSetCalculator.addItemDuration(item: item, startTime: startTimeOfItem) ;
      item.save();
      timeSet.save();

    });
  }

  void setItemStartTime(Item item, DateTime startTime) {
    item.startTimeItemHours = startTime.hour;
    item.startTimeItemMinutes = startTime.minute;
    item.startTimeItemSeconds = startTime.second;
  }

  void addListItems(int counter, int startNumber, TimeSet timeSet) {
    //запуск цикла добавления items в список TimeSet
    for (int i = 0; i < counter; i++) {
      Item item = Item(
          titleItem: '',
          chipsItem: <String>[startNumber.toString()],
          startTimeItemHours: timeSet.startHours,
          startTimeItemMinutes: timeSet.startMinutes,
          startTimeItemSeconds: 0,
          isVerse: false,
          isPicture: false,
          isTable: false);
      addItemInListTimeSet(timeSet, item);
      startNumber =  startNumber+1   ;
    }
  }

  void addItemInListTimeSet(
      TimeSet timeSet, Item item) async {
    await addItemInTimeSet(timeSet, item);//добавляем item в timeSet HiveList itemList
    //changeDurationOfItems(timeSet); //пересчитываем среднюю продолжительность item
    //calculateStartTimeInListItems(timeSet: timeSet); //пересчитываем новый startTime of item
    updateListItems(timeSet);
    ///TODO adding number chips
    //     // await addNumberChipsInHive(startNumber);
  }

  void changeDurationOfItems(TimeSet timeSet) {
    //вычисляем среднюю продолжительность item
    _averageDurationOfItem = _timeSetCalculator.calcAverageDurationOfItem(timeSet);
    // присваиваем среднюю продолжительность averageDuration для item
    timeSet.items?.forEach((item) {_itemsDataProvider.setupDurationForItem(item, _averageDurationOfItem); });
  }

  void updateListItems(TimeSet timeSet){
    changeDurationOfItems(timeSet);
    calculateStartTimeInListItems(timeSet: timeSet);
  }

  Future<void> saveListOfItemsForNewTimeSet(TimeSet timeSet, List<Item> items) async {
    await _itemsDataProvider.saveListOfItemsInHive(timeSet, items);
    //await _itemsDataProvider.addItemListAsHiveList(timeSet, _items);
  }

  Future<void> addItemInTimeSet(TimeSet timeSet, Item item) async {
    await _itemsDataProvider.addItemInHiveBox(item);
    await _itemsDataProvider.addItemAsHiveList(timeSet, item);
    item.save();
    timeSet.save();
    ///TODO adding number chips
    // await addNumberChipsInHive(startNumber);
  }

  void deleteItemFromList(TimeSet timeSet, int keyOfTimeSet) async {
    await _itemsDataProvider.deleteItemFromList(timeSet, keyOfTimeSet);
  }

  void deleteListOfItems(TimeSet timeSet) {
    _itemsDataProvider.deleteListOfItems(timeSet);
  }

  Future<void> closeTimeSetHiveBox() async {
    await _itemsDataProvider.closeBoxOfItems();
  }
}
