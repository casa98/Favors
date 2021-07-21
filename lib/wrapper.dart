import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:do_favors/screens/auth/authenticate.dart';
import 'package:do_favors/screens/home/home_page.dart';

class Wrapper extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          // Successfully connected to the app
          return StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  User? user = snapshot.data;
                  if (user == null) {
                    return Authenticate();
                  } else {
                    return HomePage('Unassigned Favors');
                  }
                }
                return Scaffold(
                  body: Center(
                    child: Scaffold(backgroundColor: Color(0xff151e32)),
                  ),
                );
              });
        }
        // Still connecting (loading)
        return Scaffold(
          body: Center(
            child: Scaffold(backgroundColor: Color(0xff151e32),),
          ),
        );
      },
    );
  }
}
