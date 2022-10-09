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
    final items = context.read<TimeSetModule>().listOfItems;
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
      child: const CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 64.0,
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

class ListOfItemWidgets extends StatefulWidget {
  const ListOfItemWidgets({Key? key}) : super(key: key);

  @override
  State<ListOfItemWidgets> createState() => _ListOfItemWidgetsState();
}

class _ListOfItemWidgetsState extends State<ListOfItemWidgets> {
  @override
  Widget build(BuildContext context) {
    final _listOfItems = context.watch<TimeSetModule>().listOfItems;

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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditItemScreen(item: item)));
            },
          );
        },
        childCount: _listOfItems.length,
      ),
    );
  }
}
