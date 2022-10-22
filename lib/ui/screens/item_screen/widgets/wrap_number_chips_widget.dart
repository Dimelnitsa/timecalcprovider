import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../item_screen_view_model.dart';

class WrapNumberChipsWidget extends StatelessWidget {
  const WrapNumberChipsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final numberChips =
    context.select((ItemScreenViewModel model) => model.numberChips);
    final itemChips = context.watch<ItemScreenViewModel>().itemChips;

    return ListTile(
      title: SizedBox(
        height: 40,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: numberChips.length,
          itemBuilder: (context, index) {
            return ChoiceChip(
              label: Text(numberChips[index].number.toString()),
              labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.white),
              selected:
              itemChips!.contains(numberChips[index].number.toString()),
              selectedColor: Colors.blueGrey,
              backgroundColor: Colors.blueGrey[200],
              onSelected: (isSelected) {
                if (isSelected) {
                  context
                      .read<ItemScreenViewModel>()
                      .addItemChips(numberChips[index].number.toString());
                } else {
                  context
                      .read<ItemScreenViewModel>()
                      .removeItemChips(numberChips[index].number.toString());
                }
              },
            );
          },
        ),
      ),
      // trailing: IconButton(
      //    onPressed:
      //    context.read<EditItemModel>().addNumberChips,
      //    icon: const Icon(Icons.add)),
    );
  }
}