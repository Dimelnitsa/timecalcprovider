
import 'package:flutter/material.dart';
import '../ui/screens/new_item_screen/new_item_screen.dart';
import '../ui/screens/timeset_screen/timeset_screen.dart';
import '../repository/settings.dart';


abstract class AppNavigationRoutsName{
  static const home = '/';
  static const settings = '/settings';
  static const newItemScreen = '/newitem';
}

class MainNavigation {
  final initialRoute = AppNavigationRoutsName.home;
  final routes = <String, Widget Function(BuildContext)>{
    AppNavigationRoutsName.home: (context) => const TimeSetScreen(),
    AppNavigationRoutsName.settings: (context) => const SettingsScreen(),
    AppNavigationRoutsName.newItemScreen: (context) => const NewItemScreen(),
  };
}

