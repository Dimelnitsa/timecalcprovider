import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timecalcprovider/repository/item.dart';
import '../timeset_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ItemWidget extends StatelessWidget {
  const ItemWidget({Key? key, required this.item, required this.index})
      : super(key: key);

  final Item item;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 5.0),
      // padding:
      //     const EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
      decoration: BoxDecoration(
        color: Colors.blueGrey[200],
        borderRadius: const BorderRadius.all(
          Radius.circular(5.0),
        ),
      ),
      child: ListTile(
        leading: StartTime(item: item),
        title: Wrap(
          children: [
            Wrap(
              alignment: WrapAlignment.start,
              children: item.chipsItem!
                  .map((value) => InputChip(
                        label: Text(value),
                        labelStyle: const TextStyle(color: Colors.black),
                        disabledColor: Colors.white,
                      ))
                  .toList(),
            ),
            if (item.isPicture) IsPictureButton(item: item),
            if (item.isVerse) IsVerceButton(item: item),
            if (item.isTable) IsTableButton(item: item),
          ],
        ),
        subtitle: item.titleItem != '' ? ItemTitle(item: item) : null,
        trailing: MyPopupMenuButton(item: item, index: index),
      ),
    );
  }
}

class MyPopupMenuButton extends StatelessWidget {
  const MyPopupMenuButton({
    Key? key,
    required this.index,
    required this.item,
  }) : super(key: key);

  final int index;
  final Item item;

  @override
  Widget build(BuildContext context) {
    // final _timeSet= context.watch<TimeModule>().timeSet;
    final local = AppLocalizations.of(context)!;
    return PopupMenuButton(
        onSelected: (value) {
          switch (value) {
            case 1:
              context.read<TimeSetModule>().insertItemAbove(index);
              break;
            case 2:
              context.read<TimeSetModule>().insertItemUnder(index);
              break;
            case 3:
              context.read<TimeSetModule>().deleteItemFromList(index);
              break;
            case 4:
              context.read<TimeSetModule>().changeIsVerse(item);
              break;
            case 5:
              context.read<TimeSetModule>().changeIsPicture(item);
              break;
            case 6:
              context.read<TimeSetModule>().changeIsTable(item);
              break;
          }
        },
        itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: 1,
                child: Row(
                  children: [Text(local.add), const Icon(Icons.arrow_upward)],
                ),
              ),
              PopupMenuItem(
                value: 2,
                child: Row(
                  children: [Text(local.add), const Icon(Icons.arrow_downward)],
                ),
              ),
              PopupMenuItem(
                value: 4,
                child: Row(
                  children: [
                    Text('${local.quote} '),
                    const Icon(Icons.menu_book)],
                ),
              ),
              PopupMenuItem(
                value: 5,
                child: Row(
                  children: [
                    Text('${local.illustration} '),
                    const Icon(Icons.photo_album)
                  ],
                ),
              ),
              PopupMenuItem(
                value: 6,
                child: Row(
                  children: [
                    Text('${local.table} '),
                    const Icon(Icons.table_rows_outlined)
                  ],
                ),
              ),
              PopupMenuItem(
                value: 3,
                child: Row(
                  children: [
                    Text('${local.delete} '),
                    const Icon(Icons.delete_forever)
                  ],
                ),
              ),
            ]);
  }
}

class StartTime extends StatelessWidget {
  const StartTime({
    Key? key,
    required this.item,
  }) : super(key: key);

  final Item item;

  @override
  Widget build(BuildContext context) {
    // final startTimeItem = TimeOfDay(
    //     hour: item.startTimeItemHours, minute: item.startTimeItemMinutes, );
    final startTime = DateTime(0, 0, 0, item.startTimeItemHours, item.startTimeItemMinutes);
    String formattedDate = DateFormat('HH:mm:ss').format(startTime);
    final durationOfItemInHours = item.durationHours;
    final durationOfItemInMinutes = item.durationInMinutes;
    final durationOfItemInSeconds = item.durationInSeconds;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Text(
        //   startTimeItem.format(context),
        //   style: const TextStyle(fontSize: 16),
        // ),
        Text(
          formattedDate,
          style: const TextStyle(fontSize: 16),
        ),
        Text(
          '$durationOfItemInHours:$durationOfItemInMinutes:$durationOfItemInSeconds',
          style: const TextStyle(fontSize: 12, color: Colors.black38),
        ),
      ],
    );
  }
}

class ItemTitle extends StatelessWidget {
  const ItemTitle({
    Key? key,
    required this.item,
  }) : super(key: key);

  final Item item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text(
        item.titleItem!,
        style: const TextStyle(
          fontSize: 16.0,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }
}

class IsTableButton extends StatelessWidget {
  const IsTableButton({
    Key? key,
    required this.item,
  }) : super(key: key);

  final Item item;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.table_rows_outlined),
      color: item.isTable ? Colors.black : Colors.grey,
      onPressed: () {
        context.read<TimeSetModule>().changeIsTable(item);
      },
    );
  }
}

class IsVerceButton extends StatelessWidget {
  const IsVerceButton({
    Key? key,
    required this.item,
  }) : super(key: key);

  final Item item;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(item.isVerse ? Icons.menu_book : Icons.menu_book_outlined),
      color: item.isVerse ? Colors.black : Colors.grey,
      onPressed: () {
        context.read<TimeSetModule>().changeIsVerse(item);
      },
    );
  }
}

class IsPictureButton extends StatelessWidget {
  const IsPictureButton({
    Key? key,
    required this.item,
  }) : super(key: key);

  final Item item;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon:
          Icon(item.isPicture ? Icons.photo_album : Icons.photo_album_outlined),
      color: item.isPicture ? Colors.black : Colors.grey,
      onPressed: () {
        context.read<TimeSetModule>().changeIsPicture(item);
      },
    );
  }
}
