import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:timecalcprovider/repository/counter_model.dart';
import 'ui/screens/timeset_screen/timeset_model.dart';
import 'ui/screens/drawer_screen/draw_screen_model.dart';
import 'navigation/navigation_routs.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  //WidgetsFlutterBinding.ensureInitialized();
  await initFlutterHive();
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (BuildContext context) => TimeSetModule()),
      ChangeNotifierProvider(create: (BuildContext context) => CounterModel()),
      ChangeNotifierProvider(create: (BuildContext context) => DrawScreenModel()),
    ], child: const MyApp()),
  );
}

Future<void> initFlutterHive() async{
  await Hive.initFlutter();
}

class MyApp extends StatelessWidget {
  static final mainNavigation = MainNavigation();
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time Calculator',
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English, no country code
        Locale('ru', ''),
        Locale('pl', ''),
        Locale('be', ''),
        Locale('uk', ''),
        Locale('es', ''),
        Locale('de', ''),
        Locale('bg', ''),
      ],
      scrollBehavior: const ConstantScrollBehavior(),
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        textTheme: const TextTheme(
          bodyText2: TextStyle(fontStyle: FontStyle.normal),
        ),
      ),
      initialRoute: mainNavigation.initialRoute,
      routes: mainNavigation.routes,
    );
  }
}

class ConstantScrollBehavior extends ScrollBehavior {
  const ConstantScrollBehavior();

  @override
  Widget buildScrollbar(
          BuildContext context, Widget child, ScrollableDetails details) =>
      child;

  @override
  Widget buildOverscrollIndicator(
          BuildContext context, Widget child, ScrollableDetails details) =>
      child;

  @override
  TargetPlatform getPlatform(BuildContext context) => TargetPlatform.macOS;

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());
}
