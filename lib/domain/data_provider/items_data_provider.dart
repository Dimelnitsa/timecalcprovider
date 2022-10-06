import 'package:hive/hive.dart';
import 'package:timecalcprovider/repository/time_set.dart';

import '../../repository/item.dart';
import 'hive_manager.dart';

class ItemsDataProvider{


  List<Item> _itemsTimeSetFromHive = [];
  List<Item> get itemsTimeSetFromHive => _itemsTimeSetFromHive;

  final Future<Box<Item>> boxOfItems = HiveManager.instance.openItemsBox();

  Future<void> loadItemsFromHive(TimeSet timeSet) async {
    _itemsTimeSetFromHive = timeSet.items as List<Item>;
    // numberChips = timeSet.numberChips as List<NumberChipData>;
  }

}