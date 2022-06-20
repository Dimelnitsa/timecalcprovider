import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:timecalcprovider/navigation/navigation_routs.dart';
import '../dialogs_screen/save_set_dialog.dart';
import '../drawer_screen/drawer_screen.dart';
import 'list_of_items.dart';
import 'timeset_model.dart';
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
    final _timeSet = context.watch<TimeSetModule>().timeSet;

    return Scaffold(
      appBar: AppBar(
        title: Text(_timeSet.title),
        actions: [
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
        ],
      ),
      drawer: const DrawerScreen(),
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          if (notification.direction == ScrollDirection.forward) {
            bool visibility = true;
            context.read<TimeSetModule>().changeFabVisible(visibility);
          } else if (notification.direction == ScrollDirection.reverse &&
              context.read<TimeSetModule>().itemsTimeSet.isNotEmpty) {
            bool visibility = false;
            context.read<TimeSetModule>().changeFabVisible(visibility);
          }
          return true;
        },
        child: const CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 64.0,
              flexibleSpace: TimeInsertPallet(),
              backgroundColor: Colors.white,
              floating: true,
              snap: true,
            ),
            ListOfItems(),
          ],
        ),
      ),
      floatingActionButton: fabVisible ? const MenuFab() : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
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

class MenuFab extends StatelessWidget {
  const MenuFab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      overlayOpacity: 0.5,
      overlayColor: Colors.grey,
      children: [
        SpeedDialChild(
          label: AppLocalizations.of(context)!.single,
          onTap: () {
            Navigator.pushNamed(context, AppNavigationRoutsName.newItemScreen);
          },
        ),
        SpeedDialChild(
          label: AppLocalizations.of(context)!.several,
          onTap: () {
            context.read<TimeSetModule>().showDialogAddNumeralItems(context);
          },
        )
      ],
    );
  }
}

class TimeInsertPallet extends StatelessWidget {
  const TimeInsertPallet({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: const [
        StartInputTextField(),
        DurationInputTextField(),
        FinishInputTextField()
      ],
    );
  }
}

class StartInputTextField extends StatelessWidget {
  const StartInputTextField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timeSet = context.watch<TimeSetModule>().timeSet;
    final startSet = context.watch<TimeSetModule>().startTimeOfSet(timeSet).format(context);
    final startController = TextEditingController(text: startSet);

    return Flexible(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 4.0),
        child: TextField(
          controller: startController,
          readOnly: true,
          textAlignVertical: TextAlignVertical.center,
          style: const TextStyle(
            fontSize: 20,
          ),
          decoration: const InputDecoration(

            isCollapsed: true,
           // contentPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
            prefixIcon: Icon(Icons.hourglass_top),
            //labelText: 'Start',
            //helperText: 'Start' ,
            //border: OutlineInputBorder(),
            // suffixIcon: IconButton(
            //   icon: const Icon(Icons.arrow_right),
            //   onPressed: (){
            //     context.read<TimeModule>().changeStartTime(context);
            //   },),
          ),
          onTap: () {
            context.read<TimeSetModule>().changeStartTime(context);
          },
        ),
      ),
    );
  }
}

class DurationInputTextField extends StatelessWidget {
  const DurationInputTextField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final duration = context.watch<TimeSetModule>().duration();
    final durationController = TextEditingController(text: duration);

    return Flexible(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4.0, 0.0, 0.0, 0.0),
        child: TextField(
          controller: durationController,
          readOnly: true,
          textAlignVertical: TextAlignVertical.center,
          style: const TextStyle(
            fontSize: 20,
          ),
          decoration: const InputDecoration(
            isCollapsed: true,
           // contentPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
            prefixIcon: Icon(Icons.hourglass_empty),
            // suffixIcon: IconButton(
            //   icon: const Icon(Icons.arrow_right),
            //   onPressed: () {
            //     context.read<TimeModule>().changeDuration(context);
            //   },),
           // labelText: 'Duration',
            //helperText: 'Duration' ,
           // border: OutlineInputBorder(),
          ),
          onTap: () {
            context.read<TimeSetModule>().changeDuration(context);
          },
        ),
      ),
    );
  }
}

class FinishInputTextField extends StatelessWidget {
  const FinishInputTextField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final finish = context.watch<TimeSetModule>().finishTime().format(context);
    final finishController = TextEditingController(text: finish);
    return Flexible(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4.0, 0.0, 0.0, 0.0),
        child: TextField(
          controller: finishController,
          readOnly: true,
          textAlignVertical: TextAlignVertical.center,
          style: const TextStyle(
            fontSize: 20,
          ),
          decoration: const InputDecoration(
            isCollapsed: true,
           // contentPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
            prefixIcon: Icon(Icons.hourglass_bottom),
            // suffixIcon: IconButton(
            //   icon: const Icon(Icons.arrow_right),
            //   onPressed: () {
            //     context.read<TimeModule>().changeFinishTime(context);
            //   },
            // ),
            //labelText: 'Finish',
            //helperText: 'Finish' ,
            //border: OutlineInputBorder(),
          ),
          onTap: () {
            context.read<TimeSetModule>().changeFinishTime(context);
          },
        ),
      ),
    );
  }
}
