import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_favors/provider/user_provider.dart';

import 'package:do_favors/shared/constants.dart';

class UnassignedFavorsController {
  UserProvider _currentUser;
  UserProvider get currentUser => _currentUser;

  UnassignedFavorsController(this._currentUser);

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchUnassignedFavors() {
    return FirebaseFirestore.instance
        .collection(FAVORS)
        .where(FAVOR_STATUS, isEqualTo: -1)
        .orderBy(FAVOR_TIMESTAMP, descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchUnconfirmedFavors() {
    return FirebaseFirestore.instance
        .collection(FAVORS)
        .where(FAVOR_USER, isEqualTo: _currentUser.id)
        .snapshots();
  }
}
