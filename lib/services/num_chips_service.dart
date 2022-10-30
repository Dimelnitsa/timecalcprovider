import '../domain/data_provider/num_chips_data_provider.dart';

import '../repository/number_chips_data.dart';
import '../repository/time_set.dart';

class NumberChipsService {
  final _numberChipsDataProvider = NumberChipsDataProvider();
  late List<NumberChipData> _numberChips;
  List<NumberChipData> get numberChips => _numberChips;

  List<NumberChipData> getListOfNumberChips(TimeSet timeSet) {
    if ((_numberChipsDataProvider.loadNumberChipsFromHive(timeSet)) == null) {
      _numberChips = [];
      return _numberChips;
    } else {
      _numberChips =
          (_numberChipsDataProvider.loadNumberChipsFromHive(timeSet))!;
      return _numberChips;
    }
  }

  Future<void> saveListOfNumberChips(TimeSet timeSet) async {
    await _numberChipsDataProvider
        .saveListNumberChipsAsNewTimeSetInHive(_numberChips);
    await _numberChipsDataProvider.addListNumberChipsAsHiveList(
        timeSet, _numberChips);
  }

  Future<void> addNumberChipInHive(TimeSet timeSet, int number) async {
    final numberChipData = NumberChipData(number: number, isSelected: false);

    final _listNumberChipsInHive =
        _numberChips.map((numberChip) => numberChip.number).toList();

    if (!_listNumberChipsInHive.contains(number)) {
      await _numberChipsDataProvider.addNumberChipsInHiveBox(numberChipData);
      await _numberChipsDataProvider.addNumberChipsAsHiveList(
          timeSet, numberChipData);
      _numberChipsDataProvider.saveChangesNumberChipsInHive(numberChipData);
      timeSet.save();
    }
  }

  Future<void> addListOfNumberChips(
      TimeSet timeSet, int startNumber, int counter) async {
    for (int i = 0; i < counter; i++) {
      addNumberChipInHive(timeSet, startNumber);
      startNumber = startNumber + 1;
    }
  }

  void deleteListOfNumberChips(TimeSet timeSet) {
    _numberChipsDataProvider.deleteListOfNumberChipsInHive(timeSet);
  }

  Future<void> closeBoxOfNumberChips() async {
    await _numberChipsDataProvider.closeBoxOfNumberChips();
  }
}
