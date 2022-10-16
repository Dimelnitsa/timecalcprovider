import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timecalcprovider/services/session_service.dart';
import '../domain/data_provider/time_set_data_provider.dart';
import '../repository/time_set.dart';

class TimeSetService {

  var _timeSet= TimeSet(
      title: 'Новый',
      startHours: TimeOfDay.now().hour.toInt(),
      startMinutes: TimeOfDay.now().minute.toInt(),
      dateTimeSaved: DateTime.now());
  TimeSet get timeSet => _timeSet;
  final _timeSetDataProvider = TimeSetDataProvider();

  final _sessionService = SessionService();

  Future<TimeSet> loadTimeSet(String keyOfTimeSet) async {
    if ((await _timeSetDataProvider.getTimeSetFromHive(keyOfTimeSet)) == null){
      _sessionService.saveLastSession(_timeSet.title);
      return _timeSet;
    } else {
      _timeSet = (await _timeSetDataProvider.getTimeSetFromHive(keyOfTimeSet))!;
      _sessionService.saveLastSession(_timeSet.title);
      return _timeSet;
    }

  }

  Future<List<TimeSet>> loadListOfTimeSets()async {
    return await _timeSetDataProvider.listOTimeSetsFromHive();
  }

  Future<void> saveChangesTimeSet()async{
    _timeSetDataProvider.saveChangesOfTimeSetInHive(timeSet);
  }

  Future<void> saveNewTimeSet(String title) async {
    final _savedTimeSet = TimeSet(
        title: title,
        startHours: timeSet.startHours,
        startMinutes: timeSet.startMinutes,
        hoursDuration: timeSet.hoursDuration,
        minutesDuration: timeSet.minutesDuration,
        dateTimeSaved: timeSet.dateTimeSaved);
    _timeSetDataProvider.saveTimeSetInHive(title, _savedTimeSet);
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
    await _timeSetDataProvider.saveChangesOfTimeSetInHive(_timeSet);


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
      //  _itemListService.changeDurationOfItems(_timeSet);
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
