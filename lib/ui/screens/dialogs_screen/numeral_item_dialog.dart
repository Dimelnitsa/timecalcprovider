
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:timecalcprovider/repository/counter_model.dart';
import '../timeset_screen/time_set_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NumeralItemDialog extends StatefulWidget {
  const NumeralItemDialog({Key? key}) : super(key: key);
  @override
  State<NumeralItemDialog> createState() => _NumeralItemDialogState();
}

class _NumeralItemDialogState extends State<NumeralItemDialog> {

  @override
  Widget build(BuildContext context) {
    final _modelWatch = context.watch<CounterModel>();
    final _modelRead = context.read<CounterModel>();

    int startNumber = _modelWatch.startNumber;
    int counter = _modelWatch.counter;


    final _controller = TextEditingController(text: '$counter');
    final _controllerStartNumber = TextEditingController(text: '$startNumber');

    return AlertDialog(
      // title: const Text('Добавить несколько'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(AppLocalizations.of(context)!.how_many_points),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: _modelRead.decrementCounter,
                  ),
                  SizedBox(
                    width: 63.0,
                    child: TextField(
                      controller: _controller,
                      readOnly: true,
                      // keyboardType: TextInputType.number,
                      // maxLines: 1,
                      //autofocus: true,
                      //inputFormatters: [MyInputTextFormatter()],
                      //scrollPadding: EdgeInsets.all(8),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        isCollapsed: true,
                        contentPadding: const EdgeInsets.all(8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      // onChanged: (value) {
                      //   _modelRead.setCounter(value);
                      //   },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _modelRead.incrementCounter,
                  ),
                ],
              ),
            ),
            const Divider(
              height: 16.0,
            ),
             Text(AppLocalizations.of(context)!.starting_digit),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8.0),
          ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: _modelRead.decrementStartNumber,
                ),
                SizedBox(
                  width: 63.0,
                  child: TextField(
                    controller: _controllerStartNumber,
                    readOnly: true,
                    // keyboardType: TextInputType.number,
                    // maxLines: 1,
                    //autofocus: true,
                    //inputFormatters: [MyInputTextFormatter()],
                    //scrollPadding: EdgeInsets.all(8),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      isCollapsed: true,
                      contentPadding: const EdgeInsets.all(8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        startNumber = int.parse(value);
                      });
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _modelRead.incrementStartNumber,
                ),
              ],
            ),
        ),
          ],
        ),
      ),
      actions: <Widget>[
        MaterialButton(
          elevation: 5.0,
          child: Text(AppLocalizations.of(context)!.ok),
          onPressed: () {
            context.read<TimeSetModule>().addListItems(counter, startNumber);
            _modelRead.startNumber = startNumber + counter;

            Navigator.of(context).pop();
          },
        ),
        MaterialButton(
          elevation: 5.0,
          child: Text(AppLocalizations.of(context)!.cancel),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class MyInputTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var digitsOnly = newValue.text.replaceAll(RegExp(r'[^/d]+'), '');
    // TODO: implement formatEditUpdate
    return TextEditingValue(
      text: digitsOnly,
      selection: TextSelection.collapsed(offset: digitsOnly.length),
    );
  }
}
