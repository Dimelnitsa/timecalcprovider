import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'edit_item_model.dart';

class EditedItemWidget extends StatelessWidget {
  const EditedItemWidget({
    Key? key,
  })  : super(key: key);

  @override
  Widget build(BuildContext context) {
   final _itemEdited = context.watch<EditItemModel>().itemEdited;
    final _isVerse = context.select((EditItemModel value) => value.isVerse);
    final _isPicture = context.select((EditItemModel value) => value.isPicture);
    final _isTable = context.select((EditItemModel value) => value.isTable);

    return Container(
      margin:
          const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 5.0, top: 5.0),
      decoration: BoxDecoration(
        color: Colors.blueGrey[200],
        borderRadius: const BorderRadius.all(
          Radius.circular(5.0),
        ),
      ),
      child: ListTile(
        leading: const StartTime(),
        title: Wrap(
          children: [
            Wrap(
              alignment: WrapAlignment.start,
              children: _itemEdited.chipsItem!
                  .map((value) => ChoiceChip(
                        label: Text(value),
                        labelStyle: const TextStyle(color: Colors.white),
                        selected: false,
                        disabledColor: Colors.blueGrey,
                        selectedColor: Colors.blueGrey,
                      ))
                  .toList(),
            ),
            if (_isPicture) const IsPictureButton(),
            if (_isVerse) const IsVerseButton(),
            if (_isTable) const IsTableButton(),
          ],
        ),
        // subtitle: item.titleItem != '' ? ItemTitle(item: item) : null,
        trailing: const DurationItem(),
      ),
    );
  }
}

class StartTime extends StatelessWidget {
  const StartTime({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _itemEdited = context.read<EditItemModel>().itemEdited;

    final startTimeItem = TimeOfDay(
        hour: _itemEdited.startTimeItemHours, minute: _itemEdited.startTimeItemMinutes);
    return Text(
      startTimeItem.format(context),
      style: const TextStyle(fontSize: 16),
    );
  }
}

class DurationItem extends StatelessWidget {
  const DurationItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _itemEdited = context.select((EditItemModel model) => model.itemEdited);
    final startTimeItem =
        TimeOfDay(hour: _itemEdited.hoursDuration, minute: _itemEdited.minutesDuration);
    return Text(
      startTimeItem.format(context),
      style: const TextStyle(fontSize: 16),
    );
  }
}

class IsTableButton extends StatelessWidget {
  const IsTableButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.table_rows_outlined),
      color: Colors.blueGrey,
      onPressed: () {},
    );
  }
}

class IsVerseButton extends StatelessWidget {
  const IsVerseButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.menu_book),
      color: Colors.blueGrey,
      onPressed: () {},
    );
  }
}

class IsPictureButton extends StatelessWidget {
  const IsPictureButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.photo_size_select_actual_outlined),
      color: Colors.blueGrey,
      onPressed: () {},
    );
  }
}
