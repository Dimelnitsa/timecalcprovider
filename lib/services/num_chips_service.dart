import '../domain/data_provider/num_chips_data_provider.dart';

import '../repository/number_chips_data.dart';
import '../repository/time_set.dart';

class NumChipsService{

  final _numChipsDataProvider = NumChipsDataProvider();

  List<NumberChipData> _numberChips = [];
  List<NumberChipData> get numberChips => _numberChips;

  Future<List<NumberChipData>> getListOfNumberChips(TimeSet timeSet) async {
    if((await _numChipsDataProvider.loadItemsFromHive(timeSet)) == null){return _numberChips;} else{
      _numberChips = (await _numChipsDataProvider.loadItemsFromHive(timeSet))!;
      return _numberChips;
    }

  }

  Future<void> saveListOfNumberChips(TimeSet timeSet)async{
    await _numChipsDataProvider.saveListNumberChipsInHive(_numberChips);
    await _numChipsDataProvider.addListNumberChipsAsHiveList(timeSet, _numberChips);
  }

}