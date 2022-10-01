import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../timeset_model.dart';

class TimeSetupPanel extends StatelessWidget {
  const TimeSetupPanel({
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
///TODO format to DateTime
class StartInputTextField extends StatelessWidget {
  const StartInputTextField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timeSet = context.watch<TimeSetModule>().timeSet;
    final startSet =
    context.watch<TimeSetModule>().startTimeOfSet(timeSet).format(context);
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
    final duration = context.watch<TimeSetModule>().durationTimeSet();
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