import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'addTextChipsDialog/addTextChipsDialogViewModel.dart';

class AddTextChipsDialog extends StatefulWidget {
  const AddTextChipsDialog({Key? key}) : super(key: key);

  @override
  State<AddTextChipsDialog> createState() => _AddTextChipsDialogState();
}

class _AddTextChipsDialogState extends State<AddTextChipsDialog> {

  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   //final editItemModel = context.read<EditItemModel>();

    return ChangeNotifierProvider(
      create: (context) => AddTextChipsDialogModel(),
      builder: (context,  child) {
        return AlertDialog(
          title: const Text('Добавить тэг'),
          content: TextField(
            controller: _controller,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: (){
                context.read<AddTextChipsDialogModel>().saveNewTextChoiceChips(_controller.text);
                Navigator.pop(context);
              },
              child: const Text('Ok'),
            ),
          ],
        );
      }
    );
  }
}
