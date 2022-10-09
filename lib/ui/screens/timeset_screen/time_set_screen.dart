import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timecalcprovider/navigation/navigation_routs.dart';
import '../dialogs_screen/save_set_dialog.dart';
import '../drawer_screen/drawer_time_set_screen.dart';
import 'widgets/fab_menu.dart';
import 'widgets/list_of_items.dart';
import 'time_set_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TimeSetScreen extends StatefulWidget {
  const TimeSetScreen({Key? key}) : super(key: key);

  @override
  State<TimeSetScreen> createState() => _TimeSetScreenState();
}

class _TimeSetScreenState extends State<TimeSetScreen> {
  @override
  void dispose() {
    // TODO: implement dispose
    context.read<TimeSetModule>().closeHive();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fabVisible = context.watch<TimeSetModule>().isFabVisible;
    final _titleTimeSet = context.watch<TimeSetModule>().titleTimeSet();

    return Scaffold(
      appBar: AppBar(
        title: Text(_titleTimeSet),
        actions: ListOfActionButtons(context),
      ),
      drawer: const DrawerTimeSetScreen(),
      body: ListOfItems(),
      floatingActionButton: fabVisible ? const MenuFab() : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

List<Widget> ListOfActionButtons(BuildContext context){
  return [
    IconButton(
        onPressed: () {
          showDialogSaveSet(context);
        },
        icon: const Icon(Icons.save)),
    IconButton(
      onPressed: () {
        Navigator.pushNamed(context, AppNavigationRoutsName.settings);
      },
      icon: const Icon(Icons.settings),
    ),
    IconButton(
      onPressed: () {
        showDialogDeleteAll(context);
      },
      icon: const Icon(Icons.delete),
    ),
  ];
}


Future<void> showDialogSaveSet(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => const SaveSetDialog(),
  );
}

Future<void> showDialogDeleteAll(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text(AppLocalizations.of(context)!.removal),
      content: Text(AppLocalizations.of(context)!.delete_confirmation),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        TextButton(
          onPressed: () {
            context.read<TimeSetModule>().clearAllList(context);
            Navigator.of(context).pop();
          },
          child: Text(AppLocalizations.of(context)!.ok),
        ),
      ],
    ),
  );
}
