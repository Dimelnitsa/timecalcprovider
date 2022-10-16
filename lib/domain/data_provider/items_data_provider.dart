import 'package:hive/hive.dart';
import 'package:timecalcprovider/repository/time_set.dart';

import '../../repository/item.dart';
import 'hive_manager.dart';

class ItemsDataProvider {
  final Future<Box<Item>> boxOfItems = HiveManager.instance.openItemsBox();

  Future<List<Item>?> loadItemsFromHive(TimeSet timeSet) async {
    return await timeSet.items;
  }

  Future<void> addItemListAsHiveList(TimeSet timeSet, List<Item> listItems)async{
    timeSet.addItems((await boxOfItems), listItems);
  }

  void setAverageDurationOfItem(
      TimeSet timeSet, DateTime _averageDurationOfItem) {
    timeSet.items?.forEach((item) {
      _setupDurationForItem(item, _averageDurationOfItem);
      timeSet.save();
    });
  }

  void _setupDurationForItem(Item item, DateTime duration) {
    item.durationHours = duration.hour;
    item.durationInMinutes = duration.minute;
    item.durationInSeconds = duration.second;
    item.save();
  }

  Future<void> saveChangesItemInHive(Item item) async {
    await item.save();
  }


  Future<void> saveListOfItemsInHive(List<Item> listItems) async {
    final savedListParts = listItems.map((item) => Item.clone(item)).toList();
    (await boxOfItems).addAll(savedListParts);
  }


}
