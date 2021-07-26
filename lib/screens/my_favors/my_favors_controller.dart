import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:do_favors/model/user_model.dart';
import 'package:do_favors/shared/constants.dart';

class MyFavorsController {

  UserModel _currentUser;
  UserModel get currentUser => _currentUser;

  MyFavorsController(this._currentUser);

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchMyFavors(){
    return FirebaseFirestore.instance.collection(FAVORS)
        .where(FAVOR_USER, isEqualTo: _currentUser.id)
        .orderBy(FAVOR_TIMESTAMP, descending: true)
        .snapshots();
  }
}