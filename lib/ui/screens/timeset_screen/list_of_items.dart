import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../edit_item_screen/edit_item_screen.dart';
import 'timeset_model.dart';
import 'item_widget.dart';

class ListOfItems extends StatefulWidget {
  const ListOfItems({Key? key}) : super(key: key);

  @override
  State<ListOfItems> createState() => _ListOfItemsState();
}

class _ListOfItemsState extends State<ListOfItems> {
  @override
  Widget build(BuildContext context) {
    final _listOfItems = context.watch<TimeSetModule>().itemsTimeSet;

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          final item = _listOfItems[index];
          return GestureDetector(
            child: Dismissible(
                key: UniqueKey(),
                background: Container(
                  color: Colors.red,
                ),
                onDismissed: (direction) {
                  context.read<TimeSetModule>().deleteItemFromList(index);
                },
                child: ItemWidget(item: item, index: index)),
            onTap: () {
             // context.read<TimeSetModule>().showEditItemDialog(context, item);
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => EditItemScreen(item: item)));
            },
          );
        },
        childCount: _listOfItems.length,
      ),
    );
  }

}
