

import '../domain/data_provider/items_data_provider.dart';
import '../repository/item.dart';
import '../repository/time_set.dart';

class ItemListService{
 // TimeSet timeSet;

 // ItemListService({required this.timeSet});

  // List<Item> _items = [];
  // List<Item> get items => _items;

  final _itemsDataProvider = ItemsDataProvider();

  Future<List<Item>> loadListOfItems(TimeSet timeSet) async {
    return await _itemsDataProvider.loadItemsFromHive(timeSet);
    //_items = await _itemsDataProvider.itemsTimeSetFromHive;
  }





}