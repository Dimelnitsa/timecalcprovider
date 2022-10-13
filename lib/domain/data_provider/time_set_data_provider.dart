
import 'package:hive_flutter/hive_flutter.dart';
import '../../repository/time_set.dart';
import 'hive_manager.dart';

class TimeSetDataProvider {

  // var _timeSetFromHive = TimeSet(
  //     title: 'Новый',
  //     startHours: TimeOfDay.now().hour.toInt(),
  //     startMinutes: TimeOfDay.now().minute.toInt(),
  //     dateTimeSaved: DateTime.now());
  // TimeSet get timeSetFromHive => _timeSetFromHive;

  final Future<Box<TimeSet>> _boxTimeSet = HiveManager.instance.openTimeSetBox();

  Future<TimeSet> loadTimeSetFromHive(String keyOfTimeSet) async {
    //_timeSetFromHive = (await _boxTimeSet).get(keyOfTimeSet)!;
    return (await _boxTimeSet).get(keyOfTimeSet)!;
    // _itemsTimeSetFromHive = _timeSetFromHive.items as List<Item>;
    // numberChips = timeSet.numberChips as List<NumberChipData>;
  }



  Future<List<TimeSet>> listOTimeSetsFromHive() async {
    return (await _boxTimeSet).values.toList();
  }

  Future<void> closeBoxTimeSet() async {
    HiveManager.instance.closeBox((await _boxTimeSet));
  }


  // Future<void> readLastOpenedTimeSet() async {
    //boxOfItems = HiveManager.instance.openItemsBox();
    // boxNumberChips = HiveManager.instance.NumbersChoiceChipsBox();

    // if (_lastSet == 'Новый') {
    //
    //   // if there is the first time
    //   _lastSet = 'Новый';
    //   (await boxTimeSet)
    //       .put(_lastSet, timeSet); // put timeSet to Hive boxTimeSet

      // to save items in Hive
      // final _savedListParts =
      // _itemsTimeSet.map((item) => Item.clone(item)).toList();
      // (await boxOfItems).addAll(_savedListParts);
      // timeSet.addItems((await boxOfItems), _savedListParts);

      //to save numberChips in Hive
      // (await boxNumberChips).addAll(numberChips);
      // timeSet.addListNumberChips((await boxNumberChips), numberChips);

    //   timeSet.save();
    //   (await boxOfItems).listenable().addListener(() {
    //     loadTimeSetFromHive(_lastSet!);
    //   });
    // } else {
    //   await loadTimeSetFromHive(_lastSet);
      // (await boxOfItems).listenable().addListener(() {
      //   loadTimeSet(lastOpened!);
      // });
    // }
  // }

  // Future<void> saveNewTimeSet(String title) async {
  //   final _savedTimeSet = TimeSet(
  //       title: title,
  //       startHours: timeSet.startHours,
  //       startMinutes: timeSet.startMinutes,
  //       hoursDuration: timeSet.hoursDuration,
  //       minutesDuration: timeSet.minutesDuration,
  //       dateTimeSaved: timeSet.dateTimeSaved);
  //
  //   (await boxTimeSet).put(title, _savedTimeSet);
  //
  //   // final _savedListParts =
  //   // _itemsTimeSet.map((item) => Item.clone(item)).toList();
  //   // (await boxOfItems).addAll(_savedListParts);
  //   // _savedTimeSet.addItems((await boxOfItems), _savedListParts);
  //   //
  //   // final _savedListNumberChips = numberChips
  //   //     .map((numberChip) => NumberChipData.clone(numberChip))
  //   //     .toList();
  //   // (await boxNumberChips).addAll(_savedListNumberChips);
  //   // _savedTimeSet.addListNumberChips(
  //   //     (await boxNumberChips), _savedListNumberChips);
  //
  //   _savedTimeSet.save();
  //   await loadTimeSetFromHive(title);
  // }

Future<void> saveTimeSetInHive(TimeSet timeSet) async{
    await timeSet.save();
}


}
