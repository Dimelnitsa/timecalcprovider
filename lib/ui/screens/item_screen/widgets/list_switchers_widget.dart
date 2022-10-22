
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../item_screen_view_model.dart';

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
              value: context.watch<ItemScreenViewModel>().isVerse,
              onChanged: (bool value) {
                context.read<ItemScreenViewModel>().changeIsVerse(value);
              }),
        ),
        ListTile(
          leading: const Icon(Icons.photo_size_select_actual_outlined),
          title: Text('${AppLocalizations.of(context)!.discuss_illustration}: '),
          trailing: Switch(
              value: context.watch<ItemScreenViewModel>().isPicture,
              onChanged: (bool value) {
                context.read<ItemScreenViewModel>().changeIsPicture(value);
              }),
        ),
        ListTile(
          leading: const Icon(Icons.table_chart_outlined),
          title: Text('${AppLocalizations.of(context)!.discuss_frame}: '),
          trailing: Switch(
              value: context.watch<ItemScreenViewModel>().isTable,
              onChanged: (bool value) {
                context.read<ItemScreenViewModel>().changeIsTable(value);
              }),
        ),
      ],
    );
  }

}