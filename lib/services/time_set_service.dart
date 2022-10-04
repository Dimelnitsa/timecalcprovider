import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timecalcprovider/domain/data_provider/time_set_data_provider.dart';

import '../repository/time_set.dart';

class TimeSetService{

  var _timeSet = TimeSet(
      title: 'Новый',
      startHours: TimeOfDay.now().hour.toInt(),
      startMinutes: TimeOfDay.now().minute.toInt(),
      dateTimeSaved: DateTime.now());

  TimeSet get  timeSet => _timeSet;

  String _lastSet = 'Новый';

  final _timeSetDataProvider = TimeSetDataProvider();

  // TimeOfDay startTimeOfSet() => TimeOfDay(
  //     hour: _timeSet.startHours, minute: _timeSet.startMinutes);

  Future<void> saveLastSet() async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('last_opened', _lastSet);
  }

  Future<void> loadLastSet () async {
    final pref = await SharedPreferences.getInstance();
    _lastSet = pref.getString('last_opened')!;
  }

  Future<void> initialization()async {
    _timeSet = await _timeSetDataProvider.loadTimeSetFromHive(_lastSet);
  }

  Future<void> closeHive() async{
    await _timeSetDataProvider.closeBoxTimeSet();
  }


  DateTime startTimeSet() => DateTime(
      0, 1, 1, _timeSet.startHours, _timeSet.startMinutes);

  String startHhMm (){
    return DateFormat('HH:mm').format(startTimeSet());
  }
  String startHhMmSs (){
    return DateFormat('HH:mm:ss').format(startTimeSet());
  }

  // TimeOfDay finishTime() {
  //   final finishHour = startTimeOfSet(_timeSet).hour + _timeSet.hoursDuration;
  //   final finishMinutes =
  //       startTimeOfSet(_timeSet).minute + _timeSet.minutesDuration;
  //   final finish = startTimeOfSet(_timeSet)
  //       .replacing(hour: finishHour, minute: finishMinutes);
  //   return finish;
  // }

  Duration durationTimeSet (){
    return Duration(hours: _timeSet.hoursDuration, minutes: _timeSet.minutesDuration);
  }

  String durationFormatHHMm(){
    final durInDateTime = DateTime(1, 0,0,_timeSet.hoursDuration, _timeSet.minutesDuration);
    return DateFormat('HH:mm').format(durInDateTime);
  }

  DateTime finishTimeSet (){
    return startTimeSet().add(durationTimeSet ());
  }

  String finishFormatHhMm (){
    return DateFormat('HH:mm').format(finishTimeSet ());
  }
  String finishHhMmSs (){
    return DateFormat('HH:mm:ss').format(finishTimeSet ());
  }

  // String durationTimeSet() {
  //   DateTime _startInDateTime = DateTime(
  //       0, 1, 1, startTimeOfSet(_timeSet).hour, startTimeOfSet(_timeSet).minute);
  //   DateTime _finishInDateTime =
  //   DateTime(0, 1, 1, finishTime().hour, finishTime().minute);
  //
  //   final _durationOfTimeSetInMinutes =
  //       _finishInDateTime.difference(_startInDateTime).inMinutes;
  //
  //   final _durationInHourFormat = _durationOfTimeSetInMinutes ~/ 60;
  //   final _durationInMinutesFormat =
  //       _durationOfTimeSetInMinutes - (_durationInHourFormat * 60).round();
  //
  //   return '$_durationInHourFormat:$_durationInMinutesFormat';
  // }


  // Future<void> changeStartTime(BuildContext context) async {
  //   final TimeOfDay? newValue = await showTimePicker(
  //     context: context,
  //     initialTime: startTimeOfSet(_timeSet),
  //   );
  //   if (newValue == null) {
  //     startTimeOfSet(_timeSet);
  //   } else {
  //     _timeSet.startHours = newValue.hour;
  //     _timeSet.startMinutes = newValue.minute;
  //     _timeSet.save();
  //   }
  //   calculateStartTimeOfItems(_itemsTimeSet.length);
  //
  // }

  // Future<void> changeDuration(BuildContext context) async {
  //   final TimeOfDay? newTime = await showTimePicker(
  //     context: context,
  //     initialTime: const TimeOfDay(hour: 1, minute: 0),
  //   );
  //   newTime == null
  //       ? _timeSet.hoursDuration = 1
  //       : _timeSet.hoursDuration = newTime.hour;
  //   newTime == null
  //       ? _timeSet.minutesDuration = 0
  //       : _timeSet.minutesDuration = newTime.minute;
  //
  //   if (lastOpened != '') {
  //     timeSet.save();
  //   }
  //   calculateStartTimeOfItems(_itemsTimeSet.length);
  //   notifyListeners();
  // }

  // Future<void> changeFinishTime(BuildContext context) async {
  //   TimeOfDay? newTime = await showTimePicker(
  //     context: context,
  //     initialTime: finishTime(),
  //   );
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
  //   notifyListeners();
  // }

}