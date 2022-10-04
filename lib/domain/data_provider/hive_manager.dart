import 'package:hive/hive.dart';
import 'package:timecalcprovider/repository/number_chips_data.dart';
import '../../repository/item.dart';
import '../../repository/text_choice_chip_data.dart';
import '../../repository/time_set.dart';

class HiveManager{

  //singleton
  HiveManager._();
  static final HiveManager instance = HiveManager._();

  //универсальная функция открытия базы данных
  Future<Box<T>> _openBox<T>(
      {required String nameBox}) async {
    registerAdapter(typeId: 0, typeAdapter: TimeSetInHiveAdapter());
    registerAdapter(typeId: 2, typeAdapter: ItemAdapter());
    return Hive.openBox<T>(nameBox);
  }

  void registerAdapter<E>({required int typeId,
    required TypeAdapter<E> typeAdapter}) {
    if (!Hive.isAdapterRegistered(typeId)) {
      Hive.registerAdapter(typeAdapter);
    }
  }

  //универсальная функция закрытия базы данных
  Future<void> closeBox<T>(Box<T> box) async {
    await box.compact();
    await box.close();
  }

  // Future<Box<List>> openListsOfItemsBox() {
  //   registerAdapter(typeId: 2, typeAdapter: ItemAdapter());
  //   return Hive.openBox<List>('list_of_items_box');
  // }

  Future<Box<TimeSet>> openTimeSetBox() {
    return _openBox(nameBox: 'timeset_box');
  }

  Future<Box<Item>> openItemsBox() {
    registerAdapter(typeId: 2, typeAdapter: ItemAdapter());
    return Hive.openBox<Item>('items_box');
  }

  Future<Box<TextChoiceChipData>> TextChoiceChipsBox() {
    registerAdapter(typeId: 1, typeAdapter: TextChoiceChipDataAdapter());
    return Hive.openBox<TextChoiceChipData>('textChoiceChips');
  }

  Future<Box<NumberChipData>> NumbersChoiceChipsBox(){
    registerAdapter(typeId: 3, typeAdapter: NumberChipDataAdapter());
    return Hive.openBox<NumberChipData>('numbersChoiceChips');
  }
}