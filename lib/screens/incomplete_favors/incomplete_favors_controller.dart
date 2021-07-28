import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:do_favors/provider/user_provider.dart';
import 'package:do_favors/shared/constants.dart';

class IncompleteFavorsController {
  final UserProvider _currentUser;
  UserProvider get currentUser => _currentUser;

  IncompleteFavorsController(this._currentUser);

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchIncompleteFavors() {
    return FirebaseFirestore.instance
        .collection(FAVORS)
        .where(FAVOR_STATUS, isEqualTo: 1)
        .where(FAVOR_ASSIGNED_USER, isEqualTo: _currentUser.id)
        .orderBy(FAVOR_TIMESTAMP, descending: true)
        .snapshots();
  }
}
