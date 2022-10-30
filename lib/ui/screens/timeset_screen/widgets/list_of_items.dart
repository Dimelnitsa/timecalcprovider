import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import '../../edit_item_screen/edit_item_screen.dart';
import '../time_set_model.dart';
import 'item_widget.dart';
import 'time_setup_panel.dart';

class ListOfItems extends StatelessWidget {
  const ListOfItems({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final items = context.watch<TimeSetModule>().items;
    // final timeSet = context.watch<TimeSetModule>().timeSet;

    return NotificationListener<UserScrollNotification>(
      onNotification: (notification) {
        if (notification.direction == ScrollDirection.forward) {
          bool visibility = true;
          context.read<TimeSetModule>().changeFabVisible(visibility);
        } else if (notification.direction == ScrollDirection.reverse &&
            items.isNotEmpty) {
          bool visibility = false;
          context.read<TimeSetModule>().changeFabVisible(visibility);
        }
        return true;
      },
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 56.0,
            flexibleSpace: TimeSetupPanel(),
            backgroundColor: Colors.white,
            floating: true,
            snap: true,
          ),
          ListOfItemWidgets(),
        ],
      ),
    );
  }
}

class ListOfItemWidgets extends StatelessWidget {
   ListOfItemWidgets({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _listOfItems = context.watch<TimeSetModule>().items;

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
                child: ItemWidget(
                    index: index)),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditItemScreen(item: item,)));

            },
          );
        },
        childCount: _listOfItems.length,
      ),
    );
  }
}
