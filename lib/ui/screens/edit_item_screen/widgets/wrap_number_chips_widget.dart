import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../timeset_screen/time_set_model.dart';
import '../edit_item_model.dart';

class WrapNumberChipsWidget extends StatelessWidget {
  const WrapNumberChipsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final numberChips =
    context.select((TimeSetModule model) => model.numberChips);
    final itemChips = context.watch<EditItemModel>().itemChips;

    return ListTile(
      title: SizedBox(
        height: 52,
        child: Scrollbar(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: numberChips.length,
            itemBuilder: (context, index) {
              return ChoiceChip(
                label: Text(numberChips[index].number.toString()),
                labelStyle: const TextStyle(fontSize: 16,
                    fontWeight: FontWeight.bold, color: Colors.white),
                selected:
                itemChips!.contains(numberChips[index].number.toString()),
                selectedColor: Colors.blueGrey,
                backgroundColor: Colors.blueGrey[200],
                onSelected: (isSelected) {
                  if (isSelected) {
                    context
                        .read<EditItemModel>()
                        .addItemChips(numberChips[index].number.toString());
                  } else {
                    context
                        .read<EditItemModel>()
                        .removeItemChips(numberChips[index].number.toString());
                  }
                },
              );
            },
          ),
        ),
      ),
      // trailing: IconButton(
      //    onPressed:
      //    context.read<EditItemModel>().addNumberChips,
      //    icon: const Icon(Icons.add)),
    );
  }
}