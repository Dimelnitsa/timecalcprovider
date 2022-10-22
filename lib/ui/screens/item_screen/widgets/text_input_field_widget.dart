import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../item_screen_view_model.dart';

class TextInputFieldWidget extends StatefulWidget {
  const TextInputFieldWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<TextInputFieldWidget> createState() => _TextInputFieldWidgetState();
}

class _TextInputFieldWidgetState extends State<TextInputFieldWidget> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    final _item = context.read<ItemScreenViewModel>().itemEdited;
    _controller.text = _item.titleItem!;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text(
            '${AppLocalizations.of(context)!.description}:',
            style: const TextStyle(fontSize: 16),
          ),
          const Divider(
            height: 8.0,
          ),
          TextField(
            controller: _controller,
            maxLines: null,
            //maxLength:100 ,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            onChanged: (value) {
              context.read<ItemScreenViewModel>().changeTitle(value);
            },
          ),
        ],
      ),
    );
  }
}