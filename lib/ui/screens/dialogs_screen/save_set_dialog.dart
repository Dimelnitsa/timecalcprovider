import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../timeset_screen/time_set_model.dart';

class DialogSaveTimeSetAs extends StatefulWidget {
  const DialogSaveTimeSetAs({Key? key}) : super(key: key);
  @override
  State<DialogSaveTimeSetAs> createState() => _DialogSaveTimeSetAsState();
}

class _DialogSaveTimeSetAsState extends State<DialogSaveTimeSetAs> {
  var _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
            context.read<TimeSetModule>().saveNewTimeSetAs(_controller.text);
            Navigator.pop(context);
          },
          child: const Text('Ok'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
