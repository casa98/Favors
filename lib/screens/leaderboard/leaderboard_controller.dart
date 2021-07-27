import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:do_favors/model/user_model.dart';
import 'package:do_favors/shared/constants.dart';

class LeaderboardController {

  UserModel _currentUser;
  UserModel get currentUser => _currentUser;

  LeaderboardController(this._currentUser);

  Stream<QuerySnapshot<Map<String, dynamic>>> getUsers(){
    return FirebaseFirestore.instance.collection(USER)
        .orderBy(SCORE, descending: true)
        .snapshots();
  }
}