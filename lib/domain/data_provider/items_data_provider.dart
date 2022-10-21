
import 'package:hive/hive.dart';
import '../../repository/time_set.dart';
import '../../repository/item.dart';
import 'hive_manager.dart';

class ItemsDataProvider {
  final Future<Box<Item>> _boxOfItems = HiveManager.instance.openItemsBox();


  List<Item>? loadItemsFromHive(TimeSet timeSet) {
    return timeSet.items;
  }

  Future<void> addItemListAsHiveList(TimeSet timeSet, List<Item> listItems)async{
    timeSet.addItems((await _boxOfItems), listItems);
  }

  Future<void> addItemAsHiveList(TimeSet timeSet, Item item)async{
    timeSet.addItem((await _boxOfItems), item);
  }

  Future<void> addItemInHiveBox(Item item)async{
    (await _boxOfItems).add(item);
  }

  // void setAverageDurationOfItem(TimeSet timeSet, DateTime averageDurationOfItem) {
  //   timeSet.items?.forEach((item) async {
  //     await _setupDurationForItem(item, averageDurationOfItem);
  //     await timeSet.save();
  //   });
  // }

  Future<void> setupDurationForItem(Item item, DateTime duration)async {
    item.durationHours = duration.hour;
    item.durationInMinutes = duration.minute;
    item.durationInSeconds = duration.second;
    await item.save();
  }

  Future<void> saveChangesItemInHive(Item item) async {
    await item.save();
  }

  Future<void> saveListOfItemsInHive(List<Item> listItems) async {
    final savedListParts = listItems.map((item) => Item.clone(item)).toList();
    (await _boxOfItems).addAll(savedListParts);
  }

  Future<void> deleteItemFromList(TimeSet timeSet, int keyOfTimeSet) async {
    await timeSet.items!.deleteFromHive(keyOfTimeSet);
  }

  Future<void> deleteListOfItems(TimeSet timeSet)async{
    await timeSet.items?.deleteAllFromHive();
  }

  Future<void> closeBoxOfItems() async {
    HiveManager.instance.closeBox((await _boxOfItems));
  }
}
