
import '../domain/data_provider/items_data_provider.dart';
import '../repository/item.dart';
import '../repository/time_set.dart';
import 'time_set_calculator.dart';

class ItemListService {
  final _itemsDataProvider = ItemsDataProvider();
  TimeSetCalculator _timeSetCalculator = TimeSetCalculator();
  DateTime _averageDurationOfItem = DateTime(0, 1, 1, 1, 0, 0);

  List<Item> getListOfItems(TimeSet timeSet) {
    if ((_itemsDataProvider.loadItemsFromHive(timeSet)) == null) {
      return [];
    } else {
      return (_itemsDataProvider.loadItemsFromHive(timeSet))!;

    }
  }

  void saveItemInHive(Item item){
    _itemsDataProvider.saveChangesItemInHive(item);
  }

  /// calculation start time of items
  void calculateStartTimeInListItems({required TimeSet timeSet})  {
    DateTime startTimeOfItem = DateTime(0, 1, 1, timeSet.startHours, timeSet.startMinutes, 0);
    timeSet.items?.forEach((item) {
      _timeSetCalculator.setItemStartTime(item: item, startTime: startTimeOfItem);
      startTimeOfItem = _timeSetCalculator.addItemDuration(item: item, startTime: startTimeOfItem);
      _itemsDataProvider.saveChangesItemInHive(item);
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
      startNumber =  startNumber + 1;
    }
  }

  void addItemInListTimeSet(TimeSet timeSet, Item item) {
    _itemsDataProvider.addItemInItemsHiveBox(item);
    _itemsDataProvider.addItemAsHiveList(timeSet, item);
    _itemsDataProvider.saveChangesItemInHive(item);
    timeSet.save();
    updateListItems(timeSet);
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

  void saveListOfItemsForNewTimeSet(TimeSet timeSet, List<Item> items) {
     _itemsDataProvider.saveListOfItemsInHive(timeSet, items);
  }

  // Future<void> addItemInTimeSet(TimeSet timeSet, Item item) async {
  //   await _itemsDataProvider.addItemInItemsHiveBox(item);
  //   await _itemsDataProvider.addItemAsHiveList(timeSet, item);
  //   _itemsDataProvider.saveChangesItemInHive(item);
  //   timeSet.save();
  // }

  void insertItem(TimeSet timeSet, Item item, int index){
    final addingItem = Item.clone(item);
    _itemsDataProvider.addItemInItemsHiveBox(addingItem);
    _itemsDataProvider.insertItemInHiveList(timeSet, addingItem, index);
    _itemsDataProvider.saveChangesItemInHive(addingItem);
    updateListItems(timeSet);
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
