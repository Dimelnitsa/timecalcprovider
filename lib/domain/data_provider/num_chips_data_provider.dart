import '../../repository/number_chips_data.dart';
import '../../repository/time_set.dart';
import 'hive_manager.dart';

class NumChipsDataProvider {
  final _boxNumberChips = HiveManager.instance.NumbersChoiceChipsBox();

  Future<List<NumberChipData>?> loadItemsFromHive(TimeSet timeSet) async {
    return await timeSet.numberChips;
  }

  ///4, save list of NumberChips in Hive
  Future<void> saveListNumberChipsInHive(
      List<NumberChipData> listNumberChips) async {
    final _savedListNumberChips = listNumberChips
        .map((numberChip) => NumberChipData.clone(numberChip))
        .toList();
    (await _boxNumberChips).addAll(_savedListNumberChips);
  }

  Future<void> addListNumberChipsAsHiveList(TimeSet timeSet, List<NumberChipData> listNumberChips)async{
   timeSet.addListNumberChips((await _boxNumberChips), listNumberChips);
  }

// Future<void> addNumberChipsInHive(int startNumber) async {
//   final numberChipData =
//       NumberChipData(number: startNumber, isSelected: false);
//   final _listNumberChipsInHive = (await boxNumberChips)
//       .values
//       .map((numberChip) => numberChip.number)
//       .toList();
//   if (!_listNumberChipsInHive.contains(startNumber)) {
//     (await boxNumberChips).add(numberChipData);
//     timeSet.addNumberChip((await boxNumberChips), numberChipData);
//     timeSet.save();
//     notifyListeners();
//   }
// }

  void deleteListOfNumberChipsInHive(TimeSet timeSet){
    timeSet.numberChips?.deleteAllFromHive();
  }

  Future<void> closeBoxOfNumberChips() async {
    HiveManager.instance.closeBox((await _boxNumberChips));
  }

}
