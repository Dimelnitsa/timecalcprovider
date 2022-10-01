import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:timecalcprovider/repository/timeset.dart';
import '../../../domain/data_provider/hive_manager.dart';

class DrawScreenModel extends ChangeNotifier {
  var _timeSets = <TimeSet>[];
  late final Future<Box<TimeSet>> _timeSetBox;
  ValueListenable<Object>? _timeSetBoxListenable;


  List<TimeSet> get timeSets => _timeSets.toList();

  DrawScreenModel() {
    _setup();
  }

  Future<void> _setup() async {
    _timeSetBox = HiveManager.instance.openTimeSetBox();
    await _readTimeSetFromHive();
   _timeSetBoxListenable = (await _timeSetBox).listenable();
   _timeSetBoxListenable?.addListener(_readTimeSetFromHive);
  }

  Future<void> _readTimeSetFromHive() async {
    _timeSets = (await _timeSetBox).values.toList();
    notifyListeners();
  }


}
