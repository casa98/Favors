import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:do_favors/shared/constants.dart';

class UnassignedFavorsController {

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchUnassignedFavors(){
    return FirebaseFirestore.instance.collection(FAVORS)
        .where(FAVOR_STATUS, isEqualTo: -1)
        .orderBy(FAVOR_TIMESTAMP, descending: true)
        .snapshots();
  }
}
