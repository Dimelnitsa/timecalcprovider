
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../edit_item_model.dart';

class ListOfSwitchersWidget extends StatelessWidget {
  const ListOfSwitchersWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.menu_book_outlined),
          title: const Text('Зачитать цитату: '),
          trailing: Switch(
              value: context.watch<EditItemModel>().isVerse,
              onChanged: (bool value) {
                context.read<EditItemModel>().changeIsVerse(value);
              }),
        ),
        ListTile(
          leading: const Icon(Icons.photo_size_select_actual_outlined),
          title: const Text('Обсудить иллюстрацию: '),
          trailing: Switch(
              value: context.watch<EditItemModel>().isPicture,
              onChanged: (bool value) {
                context.read<EditItemModel>().changeIsPicture(value);
              }),
        ),
        ListTile(
          leading: const Icon(Icons.table_chart_outlined),
          title: const Text('Обсудить рамку: '),
          trailing: Switch(
              value: context.watch<EditItemModel>().isTable,
              onChanged: (bool value) {
                context.read<EditItemModel>().changeIsTable(value);
              }),
        ),
      ],
    );
  }

}