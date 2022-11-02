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

  late final Future<Box<TimeSet>> _boxTimeSet;
  Box<TimeSet> get boxTimeSet => Hive.box('timeset_box');

  TimeSetDataProvider() {
    initialBoxTimeSet();
  }

  Future<Box<TimeSet>> initialBoxTimeSet() async {
    return _boxTimeSet = HiveManager.instance.openTimeSetBox();
  }

  TimeSet? getTimeSetFromHive(String keyOfTimeSet) {
    return boxTimeSet.get(keyOfTimeSet);
  }

  Future<List<TimeSet>> listOfTimeSetsFromHive() async {
    return (await _boxTimeSet).values.toList();
  }

  Future<void> closeBoxTimeSet() async {
    HiveManager.instance.closeBox((await _boxTimeSet));
  }

  Future<void> saveTimeSetInHive(String id, TimeSet savedTimeSet) async {
    (await _boxTimeSet).put(id, savedTimeSet);
  }

  void saveChangesOfTimeSetInHive(TimeSet timeSet) {
    timeSet.save();
  }

  void deleteTimeSetFromHive(TimeSet timeSet) {
    timeSet.delete();
    boxTimeSet.compact();
  }
}
