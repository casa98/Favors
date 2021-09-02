import 'package:do_favors/shared/strings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Credits: https://www.youtube.com/watch?v=p7aIZ3aEi2w&ab_channel=EasyApproach

class LocalNotificationsService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future initializeService() async {
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
    );

    _notificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (route) async {
      // {route} is where app has to navigate when notification is tapped
      print('Navigate to: $route');
    });
  }

  static Future display(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          "favors_channel",
          "Favors Notifications Channel",
          "Favors Notifications Channel",
          importance: Importance.max,
          priority: Priority.high,
        ),
      );

      await _notificationsPlugin.show(id, message.notification?.title ?? '',
          message.notification?.body ?? '', notificationDetails,
          //payload: message.data['route'],
          payload: Strings.myFavorsRoute);
    } catch (error) {
      throw error;
    }
  }
}
