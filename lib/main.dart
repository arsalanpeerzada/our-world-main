import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:ourworldmain/app_language/world_language.dart';
import 'package:ourworldmain/constants/app_colors.dart';
import 'package:ourworldmain/main_screen/ui/main_screen.dart';
import 'package:provider/provider.dart';

import 'card_game_module/providers/crazy_eights_game_provider.dart';
import 'card_game_module/providers/thirty_one_game_provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  final rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  runApp(
    //MainScreen()
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CrazyEightsGameProvider()),
        ChangeNotifierProvider(create: (_) => ThirtyOneGameProvider()),
      ],
      child: GetMaterialApp(
        scaffoldMessengerKey: rootScaffoldMessengerKey,
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: appColor,
          colorScheme: ColorScheme.fromSwatch(
              backgroundColor:colorWhite
          ),
          textTheme: const TextTheme(
            headlineLarge: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            headlineSmall: TextStyle(fontSize: 22, fontStyle: FontStyle.italic),
            bodyMedium: TextStyle(fontSize: 12.0),
          ),
        ),
        home: MainScreen(),
        translations: WorldLanguage(),
        fallbackLocale: const Locale('ar', ''),

      ),
    ),
  );
}