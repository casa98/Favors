import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationsService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;

  static Future _onBackgroundHandler(RemoteMessage message) async {
    print('onBackgroundHandler\nMessage: ${message.messageId}');
  }

  static Future _onMessageHandler(RemoteMessage message) async {
    print('onMessageHandler\nMessage: ${message.messageId}');
  }

  static Future _onMessageOpenedApp(RemoteMessage message) async {
    print('onMessageOpenApp\nMessage: ${message.messageId}');
  }

  static Future initializeService() async {
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
