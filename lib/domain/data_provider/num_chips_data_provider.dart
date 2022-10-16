import '../../repository/number_chips_data.dart';
import '../../repository/time_set.dart';
import 'hive_manager.dart';

class NumChipsDataProvider {
  final boxNumberChips = HiveManager.instance.NumbersChoiceChipsBox();

  Future<List<NumberChipData>?> loadItemsFromHive(TimeSet timeSet) async {
    return await timeSet.numberChips;
  }

  ///4, save list of NumberChips in Hive
  Future<void> saveListNumberChipsInHive(
      List<NumberChipData> listNumberChips) async {
    final _savedListNumberChips = listNumberChips
        .map((numberChip) => NumberChipData.clone(numberChip))
        .toList();
    (await boxNumberChips).addAll(_savedListNumberChips);
  }

  Future<void> addListNumberChipsAsHiveList(TimeSet timeSet, List<NumberChipData> listNumberChips)async{
   timeSet.addListNumberChips((await boxNumberChips), listNumberChips);
  }

}
