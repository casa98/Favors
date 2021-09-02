import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:do_favors/services/local_notifications_service.dart';
import 'package:do_favors/services/api_service.dart';

class PushNotificationsService {
  static FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static User? currentUser = FirebaseAuth.instance.currentUser;
  static String? deviceToken;

  static Future _onBackgroundHandler(RemoteMessage message) async {
    print('onBackgroundHandler\nMessage: ${message.notification?.title ?? ''}');
    print(message.data);
  }

  static Future _onMessageHandler(RemoteMessage message) async {
    print('onMessageHandler\nMessage: ${message.notification?.title ?? ''}');
    print(message.data);
    // Firebase will not show heads-up notification when inside app, do it manually
    LocalNotificationsService.display(message);
  }

  static Future _onMessageOpenedApp(RemoteMessage message) async {
    print('onMessageOpenApp\nMessage: ${message.notification?.title ?? ''}');
    print(message.data);
  }

  static Future getDeviceToken() async {
    return await FirebaseMessaging.instance.getToken();
  }

  static uploadDeviceToken(String uid) async {
    final deviceToken = await getDeviceToken();
    print('Device Token: $deviceToken');
    await ApiService().uploadDeviceToken(uid: uid, deviceToken: deviceToken);
  }

  static removeDeviceToken(String uid) async {
    await ApiService().removeDeviceToken(uid: uid);
  }

  static initializeService() {
    // Not needed on Android
    if (Platform.isIOS) _messaging.requestPermission();

    // Handlers
    FirebaseMessaging.onBackgroundMessage(_onBackgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);
  }

  static stopService() {
    FirebaseMessaging.onMessage.drain();
    FirebaseMessaging.onMessageOpenedApp.drain();
  }
}
