import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:do_favors/shared/constants.dart';

class DatabaseService {

  late final userCollection;
  late final favorsCollection;
  late final User? currentUser;
  static DatabaseService? _instance;

  factory DatabaseService(){
    if(_instance != null) return _instance!;
    return DatabaseService._internal();
  }

  DatabaseService._internal(){
    userCollection = FirebaseFirestore.instance.collection(USER);
    favorsCollection = FirebaseFirestore.instance.collection(FAVORS);
    currentUser = FirebaseAuth.instance.currentUser;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchUnassignedFavors() async{
    return favorsCollection
        .where(FAVOR_STATUS, isEqualTo: -1)
        .orderBy(FAVOR_TIMESTAMP, descending: true).get();
  }

  Future saveFavor(
    String title,
    String description,
    String location,
  ) async {
    dynamic username;
    dynamic newUserScore;
    await userCollection
        .doc(currentUser!.uid)
        .get()
        .then<dynamic>((snapshot) async {
      username = snapshot[USERNAME];
      newUserScore = snapshot[SCORE] - 2;
      var key = favorsCollection.doc().id;
      return await favorsCollection.doc(key).set({
        //FAVOR_ASSIGNED_USER: '',
        //FAVOR_ASSIGNED_USERNAME: '',
        FAVOR_TIMESTAMP: DateTime.now().millisecondsSinceEpoch,
        FAVOR_DESCRIPTION: description,
        FAVOR_LOCATION: location,
        FAVOR_TITLE: title,
        FAVOR_KEY: key,
        FAVOR_STATUS: -1, // Unassigned
        FAVOR_USER: currentUser!.uid,
        FAVOR_USERNAME: username,
      }).then((value) {
        // Decrease by 2 the SCORE of the user who asked for the favor
        print(newUserScore);
        userCollection.doc(currentUser!.uid).update({
          SCORE: newUserScore,
        });
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

  Future markFavorAsCompleted(String favorId, String userId) {
    return favorsCollection.doc(favorId).update({
      FAVOR_STATUS: 2,
    }).then((value) {
      // Increase by 2 the SCORE of the user who made the favor
      userCollection.doc(userId).get().then((snapshot) {
        var userNewScore = snapshot[SCORE] + 2;
        userCollection.doc(userId).update({
          SCORE: userNewScore,
        });
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
