

import '../domain/data_provider/items_data_provider.dart';
import '../repository/item.dart';

class ItemListService{
 // TimeSet timeSet;

 // ItemListService({required this.timeSet});

  List<Item> _items = [];
  List<Item> get items => _items;

  final _itemsDataProvider = ItemsDataProvider();

  Future<void> initializationItemsListOfTimeSet(timeSet) async {
    await _itemsDataProvider.loadItemsFromHive(timeSet);
    _items = await _itemsDataProvider.itemsTimeSetFromHive;
  }





}