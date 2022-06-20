
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../edit_item_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ListOfSwitchersWidget extends StatelessWidget {
  const ListOfSwitchersWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.menu_book_outlined),
          title: Text('${AppLocalizations.of(context)!.read_a_quote}: '),
          trailing: Switch(
              value: context.watch<EditItemModel>().isVerse,
              onChanged: (bool value) {
                context.read<EditItemModel>().changeIsVerse(value);
              }),
        ),
        ListTile(
          leading: const Icon(Icons.photo_size_select_actual_outlined),
          title: Text('${AppLocalizations.of(context)!.discuss_illustration}: '),
          trailing: Switch(
              value: context.watch<EditItemModel>().isPicture,
              onChanged: (bool value) {
                context.read<EditItemModel>().changeIsPicture(value);
              }),
        ),
        ListTile(
          leading: const Icon(Icons.table_chart_outlined),
          title: Text('${AppLocalizations.of(context)!.discuss_frame}: '),
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