import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'item.dart';
import 'number_chips_data.dart';

part 'timeset_in_hive.g.dart';

@HiveType(typeId: 0)
class TimeSetInHive extends HiveObject {
  @HiveField(0)
  String title;

  //@HiveField(1)
  // TimeOfDay start;

  @HiveField(2)
  int hoursDuration;

  @HiveField(3)
  int minutesDuration;

  // @HiveField(4)
  // List<Item> setItems;

  @HiveField(5)
  DateTime dateTimeSaved;

  @HiveField(6)
  int startHours;

  @HiveField(7)
  int startMinutes;

  @HiveField(8)
  HiveList<Item>? items;

  @HiveField(9)
  HiveList<NumberChipData>? numberChips;

  TimeSetInHive(
      {this.title = 'noname',
      required this.startHours,
      required this.startMinutes,
      this.hoursDuration = 1,
      this.minutesDuration = 0,
      required this.dateTimeSaved});

  TimeOfDay start() {
    return TimeOfDay(hour: startHours, minute: startMinutes);
  }

  void addItems(Box<Item> box, List<Item> listOfItems) {
    items ??= HiveList(box);
    items?.addAll(listOfItems);
  }

  void addItem(Box<Item> box, Item item) {
    items ??= HiveList(box);
    items?.add(item);
  }

  void addNumberChip(Box<NumberChipData> box, NumberChipData numberChip) {
    numberChips ??= HiveList(box);
    numberChips?.add(numberChip);
  }

  void addListNumberChips(Box<NumberChipData> box, List<NumberChipData> listNumberChips) {
    numberChips ??= HiveList(box);
    numberChips?.addAll(listNumberChips);
  }
}
