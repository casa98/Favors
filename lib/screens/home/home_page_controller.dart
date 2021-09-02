import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:do_favors/shared/constants.dart';

class HomePageController {
  Stream<DocumentSnapshot<Map<String, dynamic>>> userScoreUpdated() {
    return FirebaseFirestore.instance
        .collection(USER)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
  }
}
