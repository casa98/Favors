import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:do_favors/provider/user_provider.dart';
import 'package:do_favors/shared/constants.dart';

class LeaderboardController {
  UserProvider _currentUser;
  UserProvider get currentUser => _currentUser;

  LeaderboardController(this._currentUser);

  Future<QuerySnapshot<Map<String, dynamic>>> getUsers() {
    return FirebaseFirestore.instance
        .collection(USER)
        .orderBy(SCORE, descending: true)
        .get();
  }
}
