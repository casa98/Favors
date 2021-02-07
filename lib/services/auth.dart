import 'package:do_favors/services/database.dart';
import 'package:do_favors/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future signInWithEmailAndPassword(String email, String passwd) async {
    String errorMessage;
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: passwd);
      return result.user;
    } catch (error) {
      switch(error.code){
        case "user-not-found":
          errorMessage = "No user registered with this email";
          break;
        case "wrong-password":
          errorMessage = "Incorrect password";
          break;
        case "unknown":
          errorMessage = "Unable to reach the server. Are you connected to internet?";
          break;
        case "operation-not-allowed":
          errorMessage = "Server error, please try again later";
          break;
        default:
          errorMessage = "Something went wrong, please try again later";
      }
      return errorMessage;
    }
  }

  Future createUserWithEmailAndPassword(
      String name, String email, String passwd) async {
    String errorMessage;
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: passwd);
      User user = result.user;
      // Create a collection with info of the user registering right now
      await createUserCollection(user.uid, email, name);
      return user;
    } catch (error) {
      print(error.toString());
      switch(error.code){
        case "email-already-in-use":
          errorMessage = "Email address already in use";
          break;
        case "unknown":
          errorMessage = "Unable to reach the server. Are you connected to internet?";
          break;
        case "operation-not-allowed":
          errorMessage = "Server error, please try again later";
          break;
        default:
          errorMessage = "Something went wrong, please try again later";
      }
      return errorMessage;
    }
  }

  Future createUserCollection(String uid, String email, String name) async {
    final CollectionReference userCollection =
    FirebaseFirestore.instance.collection(USER);
    return await userCollection.doc(uid).set({
      IMAGE: '',
      UID: uid,
      USERNAME: name,
      SCORE: 2,
      EMAIL: email,
    });
  }
}
