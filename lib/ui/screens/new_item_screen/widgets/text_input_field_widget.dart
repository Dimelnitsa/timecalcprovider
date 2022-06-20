
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../new_item_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TextInputFieldWidget extends StatelessWidget {
  const TextInputFieldWidget({
    Key? key,
  }) : super(key: key);

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
            maxLines: null,
            //maxLength:100 ,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            onChanged: (value) {
              context.read<NewItemModel>().titleItem = value;
            },
          ),
        ],
      ),
    );
  }
}
