import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:do_favors/shared/constants.dart';
import 'package:do_favors/shared/strings.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signInWithEmailAndPassword(String email, String passwd) async {
    try {
      final result = await _auth
          .signInWithEmailAndPassword(email: email, password: passwd);
      return result.user;
    } catch (error) {
      if(error is FirebaseAuthException){
        print(_getError(error.code));
      }else{
        print(error.toString());
      }
      return null;
    }
  }

  Future<User?> createUserWithEmailAndPassword(
      String name, String email, String passwd) async {
    try {
      final result = await _auth
          .createUserWithEmailAndPassword(email: email, password: passwd);
      User? user = result.user;
      if(user != null){
        // Create a collection with info of the user registering right now
        await createUserCollection(user.uid, email, name);
        // Set user name in User instance
        await user.updateDisplayName(name);
      }
      return user;
    } catch (error) {
      if(error is FirebaseAuthException){
        print(_getError(error.code));
      }else{
        print(error.toString());
      }
      return null;
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

  String _getError(String errorCode) {
    String errorMessage;
    switch(errorCode){
      case "user-not-found":
        errorMessage = Strings.userNotFound;
        break;
      case "wrong-password":
        errorMessage = Strings.wrongPassword;
        break;
      case "email-already-in-use":
        errorMessage = Strings.emailAlreadyInUse;
        break;
      case "unknown":
        errorMessage = Strings.unknownError;
        break;
      case "operation-not-allowed":
        errorMessage = Strings.operationNotAllowed;
        break;
      default:
        errorMessage = Strings.anotherError;
    }
    return errorMessage;
  }
}
