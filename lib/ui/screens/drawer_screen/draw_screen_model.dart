import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:timecalcprovider/repository/timeset_in_hive.dart';
import '../../../domain/data_provider/hive_manager.dart';

class DrawScreenModel extends ChangeNotifier {
  var _timeSets = <TimeSetInHive>[];
  late final Future<Box<TimeSetInHive>> _timeSetBox;
  ValueListenable<Object>? _timeSetBoxListenable;


  List<TimeSetInHive> get timeSets => _timeSets.toList();

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
