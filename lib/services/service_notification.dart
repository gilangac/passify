// ignore_for_file: prefer_const_constructors, prefer_final_fields

import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:passify/constant/color_constant.dart';
import 'package:passify/routes/pages.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:get/state_manager.dart';

class NotificationService extends GetxService {
  static late FirebaseMessaging _fcm;
  static late FlutterLocalNotificationsPlugin _localNotification;

  static AndroidInitializationSettings _androidInitLN =
      AndroidInitializationSettings("@mipmap/ic_launcher");
  static IOSInitializationSettings _iosInitLN = IOSInitializationSettings();
  static InitializationSettings _initSettingLN =
      InitializationSettings(android: _androidInitLN, iOS: _iosInitLN);

  static Future init() async {
    await Firebase.initializeApp();
    _fcm = FirebaseMessaging.instance;

    // final token = await _fcm.getToken();
    // print(token);

    if (GetPlatform.isIOS) {
      _fcm.requestPermission();
    }

    FirebaseMessaging.onMessage.listen(_onForeground);
    FirebaseMessaging.onBackgroundMessage(_onBackground);
    // FirebaseMessaging.onMessageOpenedApp.listen(_onOpenedFromBackground);
  }

  static Future<String?> getFcmToken() async {
    final token = await _fcm.getToken();
    return token;
  }

  static Future<String?> deleteFcmToken() async {
    await _fcm.deleteToken();
  }

  static Future _showNotification(RemoteMessage message) async {
    _localNotification = FlutterLocalNotificationsPlugin();
    await _localNotification.initialize(_initSettingLN,
        onSelectNotification: _onOpenedNotification);

    if (message.notification != null) {
      try {
        final androidDetails = AndroidNotificationDetails('1', 'Specific',
            channelDescription: 'Notification for specific user',
            fullScreenIntent: true,
            importance: Importance.max,
            priority: Priority.high);
        final iosDetails = IOSNotificationDetails();
        final generalNotificationDetails =
            NotificationDetails(android: androidDetails, iOS: iosDetails);

        await _localNotification.show(
          message.notification.hashCode,
          message.notification?.title,
          message.notification?.body,
          generalNotificationDetails,
          payload: json.encode(message.data),
        );
      } on Exception catch (e) {
        print(e);
      }
    }
  }

  static void _onForeground(RemoteMessage message) async {
    // final notificationController = Get.put(NotificationController());

    _showNotification(message);
    // notificationController.onGetNotifications();
  }

  static Future<void> _onBackground(RemoteMessage message) async {
    // final notificationController = Get.put(NotificationController());

    // await _showNotification(message);
    // _showNotification(message);
    print("Handling a background message: ${message.messageId}");
    // notificationController.onGetNotifications();
  }

  static Future<void> _onOpenedNotification(String? payload) async {
    // final notificationController = Get.put(NotificationController());
    print(payload);
    if (payload != null) {
      final jsonPayload = json.decode(payload);
      Get.toNamed(AppPages.DETAIL_POST, arguments: jsonPayload['code']);
    }
  }
}
