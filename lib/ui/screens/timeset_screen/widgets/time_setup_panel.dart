import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../time_set_model.dart';

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
        StartTimeSet(),
        DurationInputTextField(),
        FinishTimeSet()
      ],
    );
  }
}

///TODO format to DateTime
class StartTimeSet extends StatelessWidget {
  const StartTimeSet({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final startSet = context.watch<TimeSetModule>().startSet().format(context);

    return Flexible(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 4.0),
        child: GestureDetector(
          child: Row(
            children: [
              Icon(Icons.hourglass_top),
              Text(
                startSet,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
            ],
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
    final durationSet = context.watch<TimeSetModule>().durationSet();


    return Flexible(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4.0, 0.0, 0.0, 0.0),
        child: GestureDetector(
          child: Row(
            children: [
              Icon(Icons.hourglass_empty),
              Text(
                durationSet,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
            ],
          ),
          onTap: () {
            context.read<TimeSetModule>().changeDuration(context);
          },
        ),
      ),
    );
  }
}

class FinishTimeSet extends StatelessWidget {
  const FinishTimeSet({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final finishSet = context.watch<TimeSetModule>().finishSet().format(context);
    return Flexible(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4.0, 0.0, 0.0, 0.0),
        child: GestureDetector(
          child: Row(
            children: [
              Icon(Icons.hourglass_bottom),
          Text(
            finishSet,
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
            ],
          ),
          onTap: () {
            context.read<TimeSetModule>().changeFinishTime(context);
          },
        ),
      ),
    );
  }
}
