import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'new_item_model.dart';
import 'widgets/text_input_field_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NewItemScreen extends StatelessWidget {
   const NewItemScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NewItemModel(),
      child: const NewItemBody(),
    );
  }
}

class NewItemBody extends StatelessWidget {
  const NewItemBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.new_item),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const TextInputFieldWidget(),
            // const WrapItemChips(),
            const TextChoiceChips(),
            const WrapNumberChips(),
            ListTile(
              leading: const Icon(Icons.menu_book_outlined),
              title: Text('${AppLocalizations.of(context)!.read_a_quote}: '),
              trailing: Switch(
                  value: context.watch<NewItemModel>().isVerse,
                  onChanged: (bool value) {
                    context.read<NewItemModel>().changeIsVerse(value);
                  }),
            ),
            ListTile(
              leading: const Icon(Icons.photo_size_select_actual_outlined),
              title: Text('${AppLocalizations.of(context)!.discuss_illustration}: '),
              trailing: Switch(
                  value: context.watch<NewItemModel>().isPicture,
                  onChanged: (bool value) {
                    context.read<NewItemModel>().changeIsPicture(value);
                  }),
            ),
            ListTile(
              leading: const Icon(Icons.table_chart_outlined),
              title: Text('${AppLocalizations.of(context)!.discuss_frame}: '),
              trailing: Switch(
                  value: context.watch<NewItemModel>().isTable,
                  onChanged: (bool value) {
                    context.read<NewItemModel>().changeIsTable(value);
                  }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
         context.read<NewItemModel>().saveItem(context);
         Navigator.pop(context);
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}



class WrapTextChoiceChips extends StatelessWidget {
  const WrapTextChoiceChips({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //var textChoiceChips = context.watch<NewItemModel>().textChoiceChips;
    var textChoiceChips = context.select((NewItemModel model) => model.textChoiceChips);

    var itemChips = context.watch<NewItemModel>().itemChips;
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
          selected: itemChips.contains(choiceChip.label),
              selectedColor: Colors.green,
              backgroundColor: Colors.blue,
              onSelected: (isSelected) {
                context
                    .read<NewItemModel>()
                    .selectChoiceChip(choiceChip, isSelected);

                String value = choiceChip.label;
                if (isSelected) {
                  context.read<NewItemModel>().addItemChips(value);
                } else {
                  context.read<NewItemModel>().removeItemChips(value);
                }
              }))
          .toList(),
    );
  }
}

class TextChoiceChips extends StatelessWidget {
  const TextChoiceChips({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Wrap(
        spacing: 8.0,
        children: [
          const WrapTextChoiceChips(),
          InputChip(
            label: SizedBox(
              width: 150,
              child: TextField(
                decoration: InputDecoration(
                  isDense: true,
                  isCollapsed: true,
                  hintText: AppLocalizations.of(context)!.add,
                  border: InputBorder.none,
                ),
                onSubmitted: (value) {
                  context.read<NewItemModel>().saveNewTextChoiceChips(value);

                },
              ),
            ),
            onPressed: () {},
            onDeleted: () {},
          ),
        ],
      ),
    );
  }
}

class WrapNumberChips extends StatelessWidget {
  const WrapNumberChips({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final numberChips = context.watch<NewItemModel>().numberChips;

    return ListTile(
      title: Wrap(
        spacing: 2.0,
        runSpacing: 2.0,
        children: numberChips
            .map((value) => InputChip(
                label: Text('$value'),
                onPressed: () => context
                    .read<NewItemModel>()
                    .addItemChips(value.toString())))
            .toList(),
      ),
      trailing: IconButton(
          onPressed: context.read<NewItemModel>().addNumberChips,
          icon: const Icon(Icons.add)),
    );
  }
}
