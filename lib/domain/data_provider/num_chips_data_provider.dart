import '../../repository/number_chips_data.dart';
import '../../repository/time_set.dart';
import 'hive_manager.dart';

class NumChipsDataProvider{

  final boxNumberChips = HiveManager.instance.NumbersChoiceChipsBox();

  Future<List<NumberChipData>> loadItemsFromHive(TimeSet timeSet) async {
    return await timeSet.numberChips as List<NumberChipData>;
  }

}