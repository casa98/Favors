import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:do_favors/provider/local_properties_provider.dart';
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

  static Future manageDeviceToken(String? uid) async {
    if (uid != null) {
      print("CurrentUser is NOT null, send data to backend");
      // Load from preferences whether devicetoken was already uploaded to DB or not
      final _localProperties = LocalPropertiesProvider();
      final isDeviceTokenSaved = await _localProperties.loadTokenStatus();
      if (!isDeviceTokenSaved) {
        deviceToken = await getDeviceToken();
        print('Device Token: $deviceToken');
        _localProperties.saveStatus();
        ApiService().uploadDeviceToken(
          uid: uid,
          deviceToken: deviceToken!,
        );
      } else {
        print("Oh, deviceToken for CurrentUser was already saved");
      }
    } else {
      print("CurrentUser is null.");
    }
  }

  static Future initializeService() async {
    // Request permission
    _messaging.requestPermission();

    // FCM Device token
    await manageDeviceToken(currentUser?.uid ?? null);

    // Handlers
    FirebaseMessaging.onBackgroundMessage(_onBackgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);
  }
}
