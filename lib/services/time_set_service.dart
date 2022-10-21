import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timecalcprovider/services/session_service.dart';
import '../domain/data_provider/time_set_data_provider.dart';
import '../repository/time_set.dart';

class TimeSetService {
  var _timeSet = TimeSet(
      title: 'Новый',
      startHours: TimeOfDay.now().hour.toInt(),
      startMinutes: TimeOfDay.now().minute.toInt(),
      dateTimeSaved: DateTime.now());
  TimeSet get timeSet => _timeSet;

  final _timeSetDataProvider = TimeSetDataProvider();
  final _sessionService = SessionService();

  Future<TimeSet> loadTimeSet(String keyOfTimeSet) async {
    if ((await _timeSetDataProvider.getTimeSetFromHive(keyOfTimeSet)) == null) {
      _sessionService.saveLastSession(_timeSet.title);
      return _timeSet;
    } else {
      _timeSet = (await _timeSetDataProvider.getTimeSetFromHive(keyOfTimeSet))!;
      _sessionService.saveLastSession(_timeSet.title);
      return _timeSet;
    }
  }

  Future<List<TimeSet>> loadListOfTimeSets() async {
    return await _timeSetDataProvider.listOTimeSetsFromHive();
  }

  void saveChangesTimeSet() {
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

  Future<void> closeTimeSetHiveBox() async {
    await _timeSetDataProvider.closeBoxTimeSet();
  }

  ///Start time of Time Set
  DateTime startTimeSet() =>
      DateTime(0, 1, 1, _timeSet.startHours, _timeSet.startMinutes);

  void changeStartTimeSet(TimeOfDay newValue) {
    _timeSet.startHours = newValue.hour;
    _timeSet.startMinutes = newValue.minute;
  }

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

  void changeFinishTime(TimeOfDay newValue) {
    timeSet.hoursDuration = newValue.hour - startTimeSet().hour;
    timeSet.minutesDuration = newValue.minute - startTimeSet().minute;
  }
}
