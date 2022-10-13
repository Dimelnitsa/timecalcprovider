import 'package:hive/hive.dart';
import 'package:timecalcprovider/repository/time_set.dart';

import '../../repository/item.dart';
import 'hive_manager.dart';

class ItemsDataProvider {

  // List<Item> _itemsTimeSetFromHive = [];
  // List<Item> get itemsTimeSetFromHive => _itemsTimeSetFromHive;

  final Future<Box<Item>> boxOfItems = HiveManager.instance.openItemsBox();

  Future<List<Item>> loadItemsFromHive(TimeSet timeSet) async {
    return await timeSet.items as List<Item>;
    // numberChips = timeSet.numberChips as List<NumberChipData>;
  }

  void setAverageDurationOfItem(TimeSet timeSet,
      DateTime _averageDurationOfItem) {
    timeSet.items?.forEach((item) {
      _setupDurationForItem(item, _averageDurationOfItem);
      timeSet.save();
    });
  }

  void _setupDurationForItem(Item item, DateTime duration){

    item.durationHours = duration.hour;
    item.durationInMinutes = duration.minute;
    item.durationInSeconds = duration.second;
    item.save();
  }

  Future<void> saveItemInHive(Item item) async{
       await item.save();
  }
}