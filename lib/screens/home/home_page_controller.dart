import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:do_favors/provider/user_provider.dart';
import 'package:do_favors/shared/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePageController {
  //UserProvider _currentUser;
  //UserProvider get currentUser => _currentUser;

  //HomePageController(this._currentUser);

  Stream<DocumentSnapshot<Map<String, dynamic>>> userScoreUpdated() {
    return FirebaseFirestore.instance
        .collection(USER)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
  }

  void dispose() {}
}
