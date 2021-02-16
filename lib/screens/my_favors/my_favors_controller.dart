import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_favors/model/favor.dart';
import 'package:do_favors/shared/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class MyFavorsController extends GetxController {

  Future<List<Favor>> getData() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection(FAVORS)
        .where(FAVOR_USER, isEqualTo: FirebaseAuth.instance.currentUser.uid)
        .orderBy(FAVOR_TIMESTAMP, descending: true).get();

    List<Favor> list = [];
    snapshot.docs.forEach((element) {
      list.add(Favor.fromDocumentSnapShot(element));
    });
    return list;
  }
}