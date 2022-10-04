import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../timeset_screen/time_set_model.dart';
import 'draw_screen_model.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  @override
  Widget build(BuildContext context) {
    return const DrawerScreenBody();
  }

}

class DrawerScreenBody extends StatelessWidget {
  const DrawerScreenBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var timeSetsCount = context.watch<DrawScreenModel>().timeSets.length;

    return Drawer(
      child: ListView.builder(
        itemCount: timeSetsCount,
        itemBuilder: (context, index) {
          return TimeSetItem(indexInList: index);
        },
      ),
    );
  }
}

class TimeSetItem extends StatelessWidget {
  final int indexInList;
  const TimeSetItem({Key? key, required this.indexInList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _timeSetItem = context.watch<DrawScreenModel>().timeSets[indexInList];
   // final _lastOpenedTimeSet = context.select((TimeSetModule module) => module.lastOpened);
    final startTimeSet = TimeOfDay(
        hour: _timeSetItem.startHours, minute: _timeSetItem.startMinutes);

    return Container(
     // color: (_timeSetItem.title == _lastOpenedTimeSet) ? Colors.blueGrey[100] : null,
      child: ListTile(
        title: Text(_timeSetItem.title),
        subtitle: Text(
            'Start: ${startTimeSet.format(context)}/'
                ' Duration: ${_timeSetItem.hoursDuration}:${_timeSetItem.minutesDuration}'),
        onTap: () {
         // context.read<TimeSetModule>().loadTimeSet(_timeSetItem.title);
          Navigator.pop(context);
        },
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            // context.read<TimeSetModule>().deleteTimeSet(_timeSetItem.title);
          },
        ),
      ),
    );
  }
}
