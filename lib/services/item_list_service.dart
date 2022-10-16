import '../domain/data_provider/items_data_provider.dart';
import '../repository/item.dart';
import '../repository/time_set.dart';

class ItemListService {
  List<Item> _items = [];
  List<Item> get items => _items;
  DateTime _averageDurationOfItem = DateTime(0, 1, 1, 1, 0, 0);

  final _itemsDataProvider = ItemsDataProvider();

  Future<List<Item>> getListOfItems(TimeSet timeSet) async {
    if ((await _itemsDataProvider.loadItemsFromHive(timeSet)) == null) {
      return _items;
    } else {
      _items = (await _itemsDataProvider.loadItemsFromHive(timeSet))!;
      return _items;
    }
  }

  /// calculation start time of items
  void calculateStartTimeOfItems(TimeSet timeSet) {
    DateTime startDateTimeOfItem =
        DateTime(0, 1, 1, timeSet.startHours, timeSet.startMinutes, 0);

    int countOfItems = _items.length;
    for (int i = 0; i < countOfItems; i++) {
      final durationOfItemInMinutes = timeSet.items![i].durationInMinutes;
      final durationOfItemInSeconds = timeSet.items![i].durationInSeconds;
      final durationOfItem = Duration(
          minutes: durationOfItemInMinutes, seconds: durationOfItemInSeconds);

      setItemStartTime(timeSet.items![i], startDateTimeOfItem);
      _itemsDataProvider.saveChangesItemInHive(timeSet.items![i]);

      startDateTimeOfItem = startDateTimeOfItem.add(durationOfItem);
    }
  }

  void setItemStartTime(Item item, DateTime startTime) {
    item.startTimeItemHours = startTime.hour;
    item.startTimeItemMinutes = startTime.minute;
    item.startTimeItemSeconds = startTime.second;
  }

  ///Duration Calculations
  void _calcAverageDurationOfItem(TimeSet timeSet) {
    final durationTimeSet = Duration(
        hours: timeSet.hoursDuration, minutes: timeSet.minutesDuration);
    final countOfItems = _items.length;

    var durationOfItemInMinutes = durationTimeSet.inMinutes;
    double averageDurationOfItemInMinutes =
        durationOfItemInMinutes / countOfItems;
    _averageDurationOfItem =
        _dateTimeFormatDurationInMinutes(averageDurationOfItemInMinutes);

    //saveAverageDurationOfItem(countOfItems,durationOfItemHours, durationOfItemMinutes, durationOfItemSeconds);
  }

  DateTime _dateTimeFormatDurationInMinutes(double minutes) {
    var convertInHours = minutes / 60;
    int durationOfItemHours = convertInHours.floor();
    int durationOfItemMinutes = minutes.floor();
    int durationOfItemSeconds =
        ((minutes - durationOfItemMinutes) * 60).round();
    return DateTime(0, 1, 1, durationOfItemHours, durationOfItemMinutes,
        durationOfItemSeconds);
  }

  void setupDurationForItem(Item item, DateTime duration) {
    item.durationHours = duration.hour;
    item.durationInMinutes = duration.minute;
    item.durationInSeconds = duration.second;
  }

  // void _setAverageDurationOfItem(TimeSet timeSet){
  //   _items.forEach((item) {
  //     setupDurationForItem(item, _averageDurationOfItem);
  //     timeSet.save();
  //     item.save();
  //   });
  //for (int i = 0; i < countOfItems; i++) {
  //     // if (lastOpened != '') {
  //     //   // если расчет делается не впервые
  //     //   if (timeSet.items != null) {
  //     //     timeSet.items![i].durationHours = durationOfItemHours;
  //     //     timeSet.items![i].durationInMinutes = durationOfItemMinutes;
  //     //     timeSet.items![i].durationInSeconds = durationOfItemSeconds;
  //     //     timeSet.save();
  //     //     timeSet.items![i].save();
  //     //   }
  //     // } else {
  //     //   _itemsTimeSet[i].durationHours = durationOfItemHours;
  //     //   _itemsTimeSet[i].durationInMinutes = durationOfItemMinutes;
  //     //   _itemsTimeSet[i].durationInSeconds = durationOfItemSeconds;
  //     // }
  //   }
  // }

  void changeDurationOfItems(TimeSet timeSet) {
    _calcAverageDurationOfItem(timeSet);
    _itemsDataProvider.setAverageDurationOfItem(
        timeSet, _averageDurationOfItem);
  }

  Future<void> saveListOfItems(TimeSet timeSet) async {
    await _itemsDataProvider.saveListOfItemsInHive(_items);
    await _itemsDataProvider.addItemListAsHiveList(timeSet, _items);
  }
}
