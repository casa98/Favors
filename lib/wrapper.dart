import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:do_favors/services/push_notifications_service.dart';
import 'package:do_favors/screens/auth/authenticate.dart';
import 'package:do_favors/screens/home/home_page.dart';
import 'package:do_favors/provider/user_provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          if (user == null) {
            return Authenticate();
          } else {
            /// This Navigator.pop is removing the loading indicator for login/registration pages
            /// It isn't removed there because that's a listener waiting for authentication changes,
            /// and it could happen that navigtion to HomePage is made before Navigator.pop is called there,
            /// causing loading inidicator to stay visible even on HomePage (and a horrible error in console).
            /// Could be dangerous and lead to future issues
            Navigator.maybePop(context);

            // Manage deviceToken used for Push Notifications
            PushNotificationsService.manageDeviceToken(user.uid);
            // Get user info and keep it in Provider
            _getUserInfo(context: context, user: user);
            return HomePage();
          }
        }
        return Scaffold(
          body: Scaffold(backgroundColor: Color(0xff151e32)),
        );
      },
    );
  }

  _getUserInfo({required BuildContext context, required User user}) async {
    final currentUser = context.read<UserProvider>();
    currentUser.setId(user.uid);
    currentUser.setEmail(user.email!);
  }
}
