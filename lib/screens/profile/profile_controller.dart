import 'dart:io';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:do_favors/provider/user_provider.dart';
import 'package:do_favors/shared/constants.dart';

class ProfileController {
  final UserProvider _currentUser;
  UserProvider get currentUser => _currentUser;

  ProfileController(this._currentUser);

  final _storage = FirebaseStorage.instance;
  final _userCollection = FirebaseFirestore.instance.collection(USER);

  final _showLoadingIndicator = StreamController<bool>();
  Stream<bool> get showLoadingIndicator => _showLoadingIndicator.stream;

  final _userScore = StreamController<String>();
  Stream<String> get userScore => _userScore.stream;

  uploadPicture(File image) async {
    _showLoadingIndicator.sink.add(true);
    await _storage
        .ref()
        .child("profile_pictures/${_currentUser.id}.jpg")
        .putFile(image)
        .then((value) async {
      final String downloadUrl = await value.ref.getDownloadURL();
      _userCollection.doc(_currentUser.id).update({
        IMAGE: downloadUrl,
      });
      // Update user photoUrl in provider too
      //userProvider!.updateUserPhotoUrl(downloadUrl);
      _showLoadingIndicator.sink.add(false);
    });
  }

  Future<String> loadScore() async {
    final score = await FirebaseFirestore.instance
        .collection(USER)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    return 'Score: ${score[SCORE].toString()} points';
  }

  clearProvider() {
    _currentUser.clear();
  }

  dispose() {
    _showLoadingIndicator.close();
    _userScore.close();
  }
}
