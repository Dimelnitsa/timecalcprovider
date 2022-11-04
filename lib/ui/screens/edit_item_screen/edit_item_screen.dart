import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'widgets/list_switchers_widget.dart';
import '../../../repository/item.dart';
import 'edit_item_model.dart';
import 'edited_item_widget.dart';
import 'widgets/text_choice_chips_widget.dart';
import 'widgets/text_input_field_widget.dart';
import 'widgets/wrap_number_chips_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditItemScreen extends StatelessWidget {
  final Item item;
  const EditItemScreen({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ///TODO change _timeSet to real variable
    // final _timeSet = TimeSet(
    //     title: 'Новый',
    //     startHours: TimeOfDay.now().hour.toInt(),
    //     startMinutes: TimeOfDay.now().minute.toInt(),
    //     dateTimeSaved: DateTime.now());;
    return ChangeNotifierProvider(
      create: (context) => EditItemModel(itemEdited: item),
      child: const EditItemBody(),
    );
  }
}

class EditItemBody extends StatelessWidget {
  const EditItemBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.editing_item),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            EditedItemWidget(),
            TextInputFieldWidget(),
            ListOfSwitchersWidget(),
            WrapNumberChipsWidget(),
            TextChoiceChipsWidget(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<EditItemModel>().saveItem(context);
          Navigator.pop(context);
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
