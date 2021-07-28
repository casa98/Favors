import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    currentUser.setName(user.displayName ?? 'Welcome!');
    currentUser.setEmail(user.email!);
  }
}
