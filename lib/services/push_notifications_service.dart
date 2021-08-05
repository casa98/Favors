import 'package:do_favors/services/local_notifications_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationsService {
  static FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static String? token;

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

  static Future initializeService() async {
    // Request permission
    _messaging.requestPermission();

    // FCM Device token
    token = await FirebaseMessaging.instance.getToken();
    print('Token: $token');
    //TODO: Send this token to backend

    // Handlers
    FirebaseMessaging.onBackgroundMessage(_onBackgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);

    // Local Notifications
  }
}
