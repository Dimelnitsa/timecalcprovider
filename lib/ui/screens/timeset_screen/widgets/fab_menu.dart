
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../../../navigation/navigation_routs.dart';
import '../timeset_model.dart';

class MenuFab extends StatelessWidget {
  const MenuFab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      overlayOpacity: 0.5,
      overlayColor: Colors.grey,
      children: [
        SpeedDialChild(
          label: AppLocalizations.of(context)!.single,
          onTap: () {
            Navigator.pushNamed(context, AppNavigationRoutsName.newItemScreen);
          },
        ),
        SpeedDialChild(
          label: AppLocalizations.of(context)!.several,
          onTap: () {
            context.read<TimeSetModule>().showDialogAddNumeralItems(context);
          },
        )
      ],
    );
  }
}
