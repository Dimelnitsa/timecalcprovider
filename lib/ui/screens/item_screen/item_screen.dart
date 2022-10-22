import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../repository/item.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'widgets/list_switchers_widget.dart';
import 'widgets/text_choice_chips_widget.dart';
import 'widgets/text_input_field_widget.dart';
import 'item_screen_view_model.dart';
import 'widgets/item_screen_widget.dart';
import 'widgets/wrap_number_chips_widget.dart';

///TODO setup ItemScreen as one for New Item anf Edit Item
class ItemScreen extends StatelessWidget {
  final Item item;
  const ItemScreen({Key? key, required this.item,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ///TODO change _timeSet to real variable
    // final _timeSet = TimeSet(
    //     title: 'Новый',
    //     startHours: TimeOfDay.now().hour.toInt(),
    //     startMinutes: TimeOfDay.now().minute.toInt(),
    //     dateTimeSaved: DateTime.now());;
    return ChangeNotifierProvider(
      create: (context) => ItemScreenViewModel(itemEdited: item),
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
            ItemScreenWidget(),
            TextInputFieldWidget(),
            // const WrapItemChips(),
            TextChoiceChipsWidget(),
            WrapNumberChipsWidget(),
            ListOfSwitchersWidget(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<ItemScreenViewModel>().saveItem(context);
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}










