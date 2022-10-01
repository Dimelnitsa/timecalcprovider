import 'package:flutter/material.dart';

import '../repository/timeset.dart';

class TimeSetService{

  var _timeSet = TimeSet(
      title: 'Новый',
      startHours: TimeOfDay.now().hour.toInt(),
      startMinutes: TimeOfDay.now().minute.toInt(),
      dateTimeSaved: DateTime.now());

  TimeSet get  timeSet => _timeSet;



}