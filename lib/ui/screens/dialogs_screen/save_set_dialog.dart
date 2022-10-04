import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../timeset_screen/time_set_model.dart';

class SaveSetDialog extends StatefulWidget {
  const SaveSetDialog({Key? key}) : super(key: key);

  @override
  State<SaveSetDialog> createState() => _SaveSetDialogState();
}

class _SaveSetDialogState extends State<SaveSetDialog> {
  @override
  Widget build(BuildContext context) {
    var _controller = TextEditingController();

    return AlertDialog(
      title: const Text('Сохранить'),
      content: TextField(
        controller: _controller,
        // onChanged: (value){
        //   setState(() {
        //   });
        // },
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
           // context.read<TimeSetModule>().saveNewTimeSet(_controller.text);
            Navigator.pop(context);
          },
          child: const Text('Ok'),
        ),
      ],
    );
  }
}
