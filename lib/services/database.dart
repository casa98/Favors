import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_favors/model/favor.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:do_favors/shared/constants.dart';

class DatabaseService {
  final userCollection = FirebaseFirestore.instance.collection(USER);
  final favorsCollection = FirebaseFirestore.instance.collection(FAVORS);
  final User? currentUser = FirebaseAuth.instance.currentUser;
  static DatabaseService? _instance;

  factory DatabaseService() {
    if (_instance != null) return _instance!;
    return DatabaseService._internal();
  }

  DatabaseService._internal() {
    /*
    userCollection = FirebaseFirestore.instance.collection(USER);
    favorsCollection = FirebaseFirestore.instance.collection(FAVORS);
    currentUser = FirebaseAuth.instance.currentUser;
    */
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchUnassignedFavors() async {
    return favorsCollection
        .where(FAVOR_STATUS, isEqualTo: -1)
        .orderBy(FAVOR_TIMESTAMP, descending: true)
        .get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchIncompleteFavors() async {
    return favorsCollection
        .where(FAVOR_STATUS, isEqualTo: 1)
        .where(FAVOR_ASSIGNED_USER,
            isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .orderBy(FAVOR_TIMESTAMP, descending: true)
        .get();
  }

  Future saveFavor({
    required Favor favor,
    required int newScore,
  }) async {
    final key = favorsCollection.doc().id;
    return await favorsCollection.doc(key).set({
      FAVOR_TIMESTAMP: DateTime.now().millisecondsSinceEpoch,
      FAVOR_DESCRIPTION: favor.description,
      FAVOR_LOCATION: favor.location,
      FAVOR_TITLE: favor.title,
      FAVOR_KEY: key,
      FAVOR_STATUS: -1, // Unassigned
      FAVOR_USER: currentUser!.uid,
      FAVOR_USERNAME: favor.username,
    }).then((value) {
      // Decrease by 2 the SCORE of the (current) user who asked for the favor
      userCollection.doc(currentUser!.uid).update({
        SCORE: newScore,
      });
    });
  }

  Future markFavorAsAssigned(String favorId) async {
    dynamic username;
    await userCollection
        .doc(currentUser!.uid)
        .get()
        .then<dynamic>((snapshot) async {
      username = snapshot[USERNAME];
      return await favorsCollection.doc(favorId).update({
        FAVOR_STATUS: 1,
        FAVOR_ASSIGNED_USER: currentUser!.uid,
        FAVOR_ASSIGNED_USERNAME: username,
      });
    });
  }

  /// User requester confirms their favor was completed
  Future markFavorAsCompletedConfirmed(String favorId, String userId) {
    return favorsCollection.doc(favorId).update({
      FAVOR_STATUS: 0,
    }).then((value) {
      print('Gonna call this bitch');
      // Increase by 2 the SCORE of the user who made the favor
      userCollection.doc(userId).get().then((snapshot) {
        final userNewScore = snapshot[SCORE] + 2;
        userCollection.doc(userId).update({
          SCORE: userNewScore,
        });
      });
    });
  }

  /// A user making a favor marks it as completed, missing for favor requester
  /// to mark it as completed.
  Future markFavorAsCompletedUnconfirmed(String favorId) {
    return favorsCollection.doc(favorId).update({
      FAVOR_STATUS: 2,
    });
  }

  Future increaseUserScore(String userId) async {
    // Get user score first, then update it
    userCollection.doc(userId).get().then((snapshot) {
      var userNewScore = snapshot[SCORE] + 2;
      userCollection.doc(userId).update({
        SCORE: userNewScore,
      });
    });
  }

  Future deleteFavor(String favorId) {
    return favorsCollection.doc(favorId).delete();
  }
}

/*
  // This seems to be faster, but it's not Singleton and I may be driving crazy
  late final userCollection = FirebaseFirestore.instance.collection(USER);
  late final favorsCollection = FirebaseFirestore.instance.collection(FAVORS);
  late final User? currentUser = FirebaseAuth.instance.currentUser;
  static DatabaseService? _instance;

  factory DatabaseService(){
    if(_instance != null) return _instance!;
    return DatabaseService._internal();
  }

  DatabaseService._internal();
*/
