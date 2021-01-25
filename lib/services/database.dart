import 'package:do_favors/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  // Collection Reference in the Firestore DB
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection(USER);

  final CollectionReference favorsCollection =
      FirebaseFirestore.instance.collection(FAVORS);

  final User currentUser = FirebaseAuth.instance.currentUser;

  Future saveFavor(
    String title,
    String description,
    String location,
  ) async {
    dynamic username;
    dynamic newUserScore;
    await userCollection
        .doc(currentUser.uid)
        .get()
        .then<dynamic>((snapshot) async {
      username = snapshot.data()[USERNAME];
      newUserScore = snapshot.data()[SCORE] - 2;
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
        FAVOR_USER: currentUser.uid,
        FAVOR_USERNAME: username,
      }).then((value) {
        // Decrease by 2 the SCORE of the user who asked for the favor
        print(newUserScore);
        userCollection.doc(currentUser.uid).update({
          SCORE: newUserScore,
        });
      });
    });
  }

  Future markFavorAsAssigned(String favorId) async {
    dynamic username;
    await userCollection
        .doc(currentUser.uid)
        .get()
        .then<dynamic>((snapshot) async {
      username = snapshot.data()[USERNAME];
      return await favorsCollection.doc(favorId).update({
        FAVOR_STATUS: 1,
        FAVOR_ASSIGNED_USER: currentUser.uid,
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
        var userNewScore = snapshot.data()[SCORE] + 2;
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
