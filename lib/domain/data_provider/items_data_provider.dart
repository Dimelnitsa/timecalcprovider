
import 'package:hive/hive.dart';
import '../../repository/time_set.dart';
import '../../repository/item.dart';
import 'hive_manager.dart';

class ItemsDataProvider {
  late final Future<Box<Item>> _boxOfItems ;
  Box<Item> get _openedBoxOfItems => Hive.box('items_box');

  ItemsDataProvider(){
    initBoxOfItems();
  }

  Future<Box<Item>> initBoxOfItems(){
    return _boxOfItems = HiveManager.instance.openItemsBox();
  }

  List<Item>? loadItemsFromHive(TimeSet timeSet) {
    return timeSet.items;
  }


  void addItemAsHiveList(TimeSet timeSet, Item item){
    timeSet.addItem(_openedBoxOfItems, item);
  }

  void insertItemInHiveList(TimeSet timeSet, Item item, int index){
    timeSet.items?.insert(index, item);
  }

  void addItemInItemsHiveBox(Item item){
    _openedBoxOfItems.add(item);
  }

  // void setAverageDurationOfItem(TimeSet timeSet, DateTime averageDurationOfItem) {
  //   timeSet.items?.forEach((item) async {
  //     await _setupDurationForItem(item, averageDurationOfItem);
  //     await timeSet.save();
  //   });
  // }

  void setupDurationForItem(Item item, DateTime duration) {
    item.durationHours = duration.hour;
    item.durationInMinutes = duration.minute;
    item.durationInSeconds = duration.second;
    item.save();
  }

  void saveChangesItemInHive(Item item) {
    item.save();
  }

  void saveListOfItemsInHive(TimeSet timeSet, List<Item> listItems) {
    final savedListParts = listItems.map((item) => Item.clone(item)).toList();
    _openedBoxOfItems.addAll(savedListParts);
    timeSet.addItems(_openedBoxOfItems, savedListParts);
  }

  Future<void> deleteItemFromList(TimeSet timeSet, int keyOfTimeSet) async {
    await timeSet.items!.deleteFromHive(keyOfTimeSet);
  }

  Future<void> deleteListOfItems(TimeSet timeSet)async{
    await timeSet.items?.deleteAllFromHive();
    (await _boxOfItems).compact();
  }

  Future<void> closeBoxOfItems() async {
    HiveManager.instance.closeBox((await _boxOfItems));
  }
}
