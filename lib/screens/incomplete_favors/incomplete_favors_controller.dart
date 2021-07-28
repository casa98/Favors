import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:do_favors/provider/user_provider.dart';
import 'package:do_favors/shared/constants.dart';

class IncompleteFavorsController {

  UserProvider _userProvider;
  UserProvider get userProvider => _userProvider;

  IncompleteFavorsController(this._userProvider);

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchIncompleteFavors(){
    return FirebaseFirestore.instance.collection(FAVORS)
        .where(FAVOR_STATUS, isEqualTo: 1)
        .where(FAVOR_ASSIGNED_USER,
        isEqualTo: _userProvider.currentUser!.id)
        .orderBy(FAVOR_TIMESTAMP, descending: true)
        .snapshots();
  }
}