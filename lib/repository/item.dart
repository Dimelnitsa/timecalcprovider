import 'package:hive/hive.dart';

part 'item.g.dart';

@HiveType(typeId: 2)
class Item extends HiveObject {
  @HiveField(0)
  String? titleItem; // text in item

  @HiveField(1)
  List<String>? chipsItem = [];

  @HiveField(9)
  int durationHours = 0;
  @HiveField(2)
  int durationInMinutes = 0;
  @HiveField(3)
  int durationInSeconds = 0;

  @HiveField(4)
  int startTimeItemHours; // hours of item's start time
  @HiveField(5)
  int startTimeItemMinutes; // minutes of item's start time
  @HiveField(10)
  int startTimeItemSeconds; // seconds of item's start time

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
    required this.startTimeItemSeconds,
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
        startTimeItemSeconds: item.startTimeItemSeconds,
        isPicture: item.isPicture = false,
        isVerse: item.isVerse = false,
        isTable: item.isTable = false);
  }
}
