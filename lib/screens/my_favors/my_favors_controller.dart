import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:do_favors/provider/user_provider.dart';
import 'package:do_favors/shared/constants.dart';

class MyFavorsController {
  UserProvider _currentUser;
  UserProvider get currentUser => _currentUser;

  MyFavorsController(this._currentUser);

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchMyFavors() {
    return FirebaseFirestore.instance
        .collection(FAVORS)
        .where(FAVOR_USER, isEqualTo: _currentUser.id)
        .orderBy(FAVOR_TIMESTAMP, descending: true)
        .snapshots();
  }
}
