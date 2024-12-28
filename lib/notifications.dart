import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

import 'constants/storage_constants.dart';
import 'constants/string_constants.dart';
import 'fcm_model.dart';

class NotificationPlugin {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static late AndroidNotificationChannel channel;
  static final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject = BehaviorSubject<ReceivedNotification>();
  var store = GetStorage();
  final StreamController<String> selectNotificationStream = StreamController<String>.broadcast();
  final StreamController<ReceivedNotification> didReceiveLocalNotificationStream = StreamController<ReceivedNotification>.broadcast();

  Future<void> init() async {
  }

  void configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationStream.stream
        .listen((ReceivedNotification receivedNotification) async {
      if (receivedNotification.body.split(startedNewLive.tr).first.trim() !=
          store.read(userName)) {
        await showDialog(
          context: Get.context!,
          builder: (BuildContext context) => CupertinoAlertDialog(
            title: Text(receivedNotification.title),
            content: Text(receivedNotification.body),
          ),
        );
      }
    });
  }


  static Future<void> sendNotificationFCM(String token,String title,String body) async {
    FCMData data;
    FCMModel fcmModel;
    if(Platform.isAndroid){
      data=FCMData(id: "1", status: "done", title: title, body: body,clickAction: "FLUTTER_NOTIFICATION_CLICK");
      fcmModel =FCMModel(priority: "high", data: data, to: token);
    }
    else{
      data=FCMData(id: "1", status: "done", clickAction: "FLUTTER_NOTIFICATION_CLICK");
      FCMNotification notification = FCMNotification(title: title, body: body);
      fcmModel =FCMModel(priority: "high", data: data, to: token,notification:notification);
    }
    if (kDebugMode) {
      print("im in fcm $body");
    }
    if (kDebugMode) {
      print(jsonEncode(fcmModel));
    }
    final response=await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer AAAAtLMfoU8:APA91bGNKD-YjlljGwYO6IQCc1jm5YHDbm_PbQk72HWaDtJ-YCw0r0JSOFPzXlQ93z_9dJnDfq0-NC1eh_vFYYnZKU5LWH7hQ2OJxJG9UwvTS5rRwNvBE0MYYClO6HNbAU9I3VIW_7wQ',
      },
      body: jsonEncode(fcmModel),
    ).catchError((error, stackTrace) {
      debugPrint(error);
    });
    debugPrint("Notification Response code ${response.statusCode.toString()}");
  }


  static Future<void> initializePlatformSpecifics() async {
    if (Platform.isIOS) {
      await _requestIOSPermission();
    }

    channel = const AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
    );

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_notification');
    var initializeIOSSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      // onDidReceiveLocalNotification: (id, title, body, payload) async {
      //   didReceiveLocalNotificationSubject.add(
      //     ReceivedNotification(
      //       id: id,
      //       title: title ?? "",
      //       body: body ?? "",
      //       payload: payload ?? "",
      //     ),
      //   );
      // },
    );
    InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializeIOSSettings,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  static Future<void> _requestIOSPermission() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);

  }

  void setListenerForLowerVersions(Function onNotificationInLowerVersions)
  {
    didReceiveLocalNotificationSubject.listen((receivedNotification) {
      onNotificationInLowerVersions(receivedNotification);
    });
  }

  static void _showNotifications(String body, String title) async {
    var vibrationPattern = Int64List(8);

    vibrationPattern[0] = 0;
    vibrationPattern[1] = 250;
    vibrationPattern[2] = 500;
    vibrationPattern[3] = 250;
    vibrationPattern[4] = 500;
    vibrationPattern[5] = 250;
    vibrationPattern[4] = 500;
    vibrationPattern[5] = 250;
    vibrationPattern[6] = 0;

    AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      DateTime.now().millisecondsSinceEpoch.toString(),
      channel.name,
      channelDescription: channel.description,
      importance: Importance.max,
      vibrationPattern: vibrationPattern,
      autoCancel: false,
      priority: Priority.high,
      playSound: true,
      color: Colors.green,
      styleInformation: const BigTextStyleInformation(''),
    );

    DarwinNotificationDetails iosNotificationDetails = const DarwinNotificationDetails(
      presentBadge: true,
      presentAlert: true,
      presentBanner: true,
      presentSound: true
    );

    NotificationDetails notificationDetails =
    NotificationDetails(
        android: androidNotificationDetails,
        iOS: iosNotificationDetails
    );

    await flutterLocalNotificationsPlugin.show(Random().nextInt(1000), title, body, notificationDetails);
  }


  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });
}
