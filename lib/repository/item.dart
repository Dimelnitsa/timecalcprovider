import 'package:hive/hive.dart';

part 'item.g.dart';

@HiveType(typeId: 2)
class Item extends HiveObject {
  @HiveField(0)
  String? titleItem; // text in item

  @HiveField(1)
  List<String>? chipsItem = [];

  @HiveField(2)
  int hoursDuration = 1;
  @HiveField(3)
  int minutesDuration = 0;

  @HiveField(4)
  int startTimeItemHours; // start time of item in hours
  @HiveField(5)
  int startTimeItemMinutes; // start time of item in minutes

  @HiveField(6)
  bool isPicture; // need to discuss picture
  @HiveField(7)
  bool isVerse; // need to read verse
  @HiveField(8)
  bool isTable; // need to discuss table

  Item({
    this.titleItem,
    this.chipsItem,
    required this.startTimeItemHours,
    required this.startTimeItemMinutes,
    this.isPicture = false,
    this.isVerse = false,
    this.isTable = false,
  });

  factory Item.clone(Item item) {
    return Item(
        titleItem: item.titleItem,
        chipsItem: item.chipsItem,
        startTimeItemHours: item.startTimeItemHours,
        startTimeItemMinutes: item.startTimeItemMinutes,
        isPicture: item.isPicture = false,
        isVerse: item.isVerse = false,
        isTable: item.isTable = false);
  }
}
