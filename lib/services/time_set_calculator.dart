
import '../repository/item.dart';
import '../repository/time_set.dart';

class TimeSetCalculator {

  DateTime addItemDuration({
    required Item item,
    required DateTime startTime,
  }) {
    DateTime startTimeOfItem =
        DateTime(0, 1, 1, startTime.hour, startTime.minute, startTime.second);
    //конвертируем данные Item в Duration
    final durationOfItem = Duration(
        hours: item.durationHours,
        minutes: item.durationInMinutes,
        seconds: item.durationInSeconds);

    return startTimeOfItem = startTimeOfItem.add(durationOfItem);
  }

  void setItemStartTime({required Item item, required DateTime startTime}) {
    item.startTimeItemHours = startTime.hour;
    item.startTimeItemMinutes = startTime.minute;
    item.startTimeItemSeconds = startTime.second;
  }

  DateTime calcAverageDurationOfItem(TimeSet timeSet) {
    int? countOfItems = timeSet.items?.length;
    final durationTimeSet = Duration(
        hours: timeSet.hoursDuration, minutes: timeSet.minutesDuration);
    if (timeSet.items == null) {
      return DateTime(0,1,1,0,1,0);
    } else {
      var durationOfItemInMinutes = durationTimeSet.inMinutes;
      double? averageDurationOfItemInMinutes =
      (durationOfItemInMinutes / countOfItems!);
      return _formatDurationToDateTime(averageDurationOfItemInMinutes);
    }
  }

  DateTime _formatDurationToDateTime(double minutes) {
    var convertInHours = (minutes / 60);
    int durationOfItemHours = convertInHours.floor();
    int durationOfItemMinutes = minutes.floor();
    int durationOfItemSeconds =
    ((minutes - durationOfItemMinutes) * 60).round();
    return DateTime(0, 1, 1, durationOfItemHours, durationOfItemMinutes,
        durationOfItemSeconds);
  }

}
