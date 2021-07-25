import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:do_favors/screens/auth/authenticate.dart';
import 'package:do_favors/screens/home/home_page.dart';
import 'package:do_favors/model/user_model.dart';
import 'package:do_favors/provider/user_provider.dart';
import 'shared/constants.dart';

class Wrapper extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          if (user == null) {
            return Authenticate();
          } else {
            // Get user info and keep it in Provider
            _getUserInfo(
              context: context,
              user: user,
            );
            return HomePage('Unassigned Favors');
          }
        }
        return Scaffold(
          body: Center(
            child: Scaffold(backgroundColor: Color(0xff151e32)),
          ),
        );
      },
    );
  }
  _getUserInfo({required BuildContext context, required User user}) async {
    final userScore = await FirebaseFirestore.instance
        .collection(USER)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    final int score = int.parse(userScore[SCORE].toString());
    print('What goes to provider is: $score');
    UserModel currentUser = UserModel(
      id: user.uid,
      email: user.email!,
      name: user.displayName ?? 'Welcome!',
      score: score,
      photoUrl: '',
    );
    final userProvider = context.read<UserProvider>();
    userProvider.setUser(currentUser);
  }
}
