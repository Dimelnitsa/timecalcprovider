import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timecalcprovider/domain/data_provider/time_set_data_provider.dart';

import '../repository/time_set.dart';

class TimeSetService {
  var _timeSet = TimeSet(
      title: 'Новый',
      startHours: TimeOfDay.now().hour.toInt(),
      startMinutes: TimeOfDay.now().minute.toInt(),
      dateTimeSaved: DateTime.now());

  TimeSet get timeSet => _timeSet;

  String _lastSet = 'Новый';

  final _timeSetDataProvider = TimeSetDataProvider();

  // TimeOfDay startTimeOfSet() => TimeOfDay(
  //     hour: _timeSet.startHours, minute: _timeSet.startMinutes);

  Future<void> saveLastSet() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('last_opened', _lastSet);
  }

  Future<void> loadLastSet() async {
    final pref = await SharedPreferences.getInstance();
    _lastSet = pref.getString('last_opened')!;
  }

  Future<void> initialization() async {
    _timeSet = await _timeSetDataProvider.loadTimeSetFromHive(_lastSet);
  }

  Future<void> closeHive() async {
    await _timeSetDataProvider.closeBoxTimeSet();
  }

  ///Start time of Time Set
  DateTime startTimeSet() =>
      DateTime(0, 1, 1, _timeSet.startHours, _timeSet.startMinutes);

  Future<void> changeStartTimeSet(TimeOfDay newValue) async {
    _timeSet.startHours = newValue.hour;
    _timeSet.startMinutes = newValue.minute;

    //   calculateStartTimeOfItems(_itemsTimeSet.length);
    //
  }

  // String startHhMm (){
  //   return DateFormat('HH:mm').format(startTimeSet());
  // }
  // String startHhMmSs (){
  //   return DateFormat('HH:mm:ss').format(startTimeSet());
  // }

  /// Duration of Time Set
  Duration durationTimeSet() {
    return Duration(
        hours: _timeSet.hoursDuration, minutes: _timeSet.minutesDuration);
  }

  String durationFormatHHMm() {
    final durInDateTime =
        DateTime(1, 0, 0, _timeSet.hoursDuration, _timeSet.minutesDuration);
    return DateFormat('HH:mm').format(durInDateTime);
  }

  void changeDuration(newValue) {
    _timeSet.hoursDuration = newValue.hour;
    _timeSet.minutesDuration = newValue.minute;

    //   calculateStartTimeOfItems(_itemsTimeSet.length);
  }

  ///Finish time of Time Set
  DateTime finishTimeSet() {
    return startTimeSet().add(durationTimeSet());
  }

  // String finishFormatHhMm (){
  //   return DateFormat('HH:mm').format(finishTimeSet ());
  // }
  // String finishHhMmSs (){
  //   return DateFormat('HH:mm:ss').format(finishTimeSet ());
  // }

  void changeFinishTime(TimeOfDay newValue) {
    // new duration определяются исходя из нового finishTime

        timeSet.hoursDuration = newValue.hour - startTimeSet().hour;
        timeSet.minutesDuration = newValue.minute - startTimeSet().minute;
  //   if (newTime == null) {
  //     // значение hoursDuration  minutesDuration определяются исходя из предыдущей finishTime
  //     timeSet.hoursDuration = finishTime().hour - startTimeOfSet(timeSet).hour;
  //     timeSet.minutesDuration =
  //         finishTime().minute - startTimeOfSet(timeSet).minute;
  //   } else {
  //     // hoursDuration  minutesDuration определяются исходя из нового finishTime
  //     timeSet.hoursDuration = newTime.hour - startTimeOfSet(timeSet).hour;
  //     timeSet.minutesDuration = newTime.minute - startTimeOfSet(timeSet).minute;
  //   }
  //   if (lastOpened != '') {
  //     timeSet.save();
  //   }
  //   calculateStartTimeOfItems(_itemsTimeSet.length);

  }

}
