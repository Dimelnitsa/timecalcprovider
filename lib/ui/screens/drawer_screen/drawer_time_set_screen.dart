import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../timeset_screen/time_set_model.dart';

class DrawerTimeSetScreen extends StatefulWidget {
  const DrawerTimeSetScreen({Key? key}) : super(key: key);

  @override
  State<DrawerTimeSetScreen> createState() => _DrawerTimeSetScreenState();
}

class _DrawerTimeSetScreenState extends State<DrawerTimeSetScreen> {
  @override
  Widget build(BuildContext context) {
    return const DrawerScreenBody();
  }

}

class DrawerScreenBody extends StatelessWidget {
  const DrawerScreenBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var timeSetsCount = context.watch<TimeSetModule>().listOfTimeSets.length;

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
    final _timeSet = context.watch<TimeSetModule>().listOfTimeSets[indexInList];
   final lastSession = context.select((TimeSetModule module) => module.lastSession);
    final startTimeSet = TimeOfDay(
        hour: _timeSet.startHours, minute: _timeSet.startMinutes);

    return Container(
     color: (_timeSet.title == lastSession) ? Colors.blueGrey[100] : null,
      child: ListTile(
        title: Text(_timeSet.title),
        subtitle: Text(
            'Start: ${startTimeSet.format(context)}/'
                ' Duration: ${_timeSet.hoursDuration}:${_timeSet.minutesDuration}'),
        onTap: () {
          context.read<TimeSetModule>().loadTimeSet(_timeSet.title);
          Navigator.pop(context);
        },
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
             context.read<TimeSetModule>().deleteTimeSet(_timeSet.title);
          },
        ),
      ),
    );
  }
}
