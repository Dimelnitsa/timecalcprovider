import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../edit_item_model.dart';

class TextChoiceChipsWidget extends StatelessWidget {
  const TextChoiceChipsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      alignment: WrapAlignment.start,
      children: [
        const WrapTextChoiceChips(),
        InputChip(
          label: SizedBox(
            width: 150,
            child: TextField(
              decoration: const InputDecoration(
                isDense: true,
                isCollapsed: true,
                hintText: 'Добавить...',
                border: InputBorder.none,
              ),
              onSubmitted: (value) {
                context.read<EditItemModel>().saveNewTextChoiceChips(value);
              },
            ),
          ),
          // onPressed: () {},
          // onDeleted: () {},
        ),
      ],
    );
  }
}

class WrapTextChoiceChips extends StatelessWidget {
  const WrapTextChoiceChips({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textChoiceChips =
    context.select((EditItemModel value) => value.textChoiceChips);
    final itemChips = context.watch<EditItemModel>().itemChips;

    return Wrap(
      alignment: WrapAlignment.start,
      spacing: 4.0,
      //runSpacing: 2.0,
      children: textChoiceChips
          .map((choiceChip) => ChoiceChip(
        label: Text(choiceChip.label),
        labelStyle: const TextStyle(
            fontWeight: FontWeight.bold, color: Colors.white),
        //selected: choiceChip.isSelected,
        selected: itemChips!.contains(choiceChip.label),
        selectedColor: Colors.blueGrey,
        backgroundColor: Colors.blueGrey[200],
        onSelected: (isSelected) {
          // context
          //     .read<EditItemModel>()
          //     .selectChoiceChip(choiceChip, isSelected);

          String value = choiceChip.label;
          if (isSelected) {
            context.read<EditItemModel>().addItemChips(value);
          } else {
            context.read<EditItemModel>().removeItemChips(value);
          }
        },
      ))
          .toList(),
    );
  }
}