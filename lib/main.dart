import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:ourworldmain/app_language/world_language.dart';
import 'package:ourworldmain/constants/app_colors.dart';
import 'package:ourworldmain/main_screen/ui/main_screen.dart';
import 'package:ourworldmain/notifications.dart';
import 'package:provider/provider.dart';

import 'card_game_module/providers/crazy_eights_game_provider.dart';
import 'card_game_module/providers/thirty_one_game_provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(NotificationPlugin.firebaseMessagingBackgroundHandler);

  if (!kIsWeb) {
    NotificationPlugin firebaseMessaging = NotificationPlugin();
    await firebaseMessaging.init();
    firebaseMessaging.selectNotificationStream.stream.listen((String payload) async {
      // await Navigator.pushNamed(Get.context!, '/secondPage');
    });
  }
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

