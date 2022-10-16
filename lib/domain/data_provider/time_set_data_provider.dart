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

  final Future<Box<TimeSet>> _boxTimeSet =
      HiveManager.instance.openTimeSetBox();

  Future<TimeSet?> getTimeSetFromHive(String keyOfTimeSet) async {
    return (await _boxTimeSet).get(keyOfTimeSet) ;
  }

  Future<List<TimeSet>> listOTimeSetsFromHive() async {
    return (await _boxTimeSet).values.toList();
  }

  Future<void> closeBoxTimeSet() async {
    HiveManager.instance.closeBox((await _boxTimeSet));
  }

  Future<void> saveTimeSetInHive(String id, TimeSet savedTimeSet) async {
    (await _boxTimeSet).put(id, savedTimeSet);
  }

  Future<void> saveChangesOfTimeSetInHive(TimeSet timeSet) async {
    await timeSet.save();
  }

}
