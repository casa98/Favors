import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_favors/shared/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rxdart/rxdart.dart';

class ProfileBloc{

  final _storage = FirebaseStorage.instance;
  final _currentUser = FirebaseAuth.instance.currentUser;
  final _userCollection =
  FirebaseFirestore.instance.collection(USER);

  Stream<bool> get showLoadingIndicator =>
      _showLoadingIndicatorSubject.stream;

  final _showLoadingIndicatorSubject = PublishSubject<bool>();

  uploadPicture(File image) async{
    _showLoadingIndicatorSubject.sink.add(true);
    await _storage.ref()
      .child("profile_pictures/${_currentUser!.uid}.jpg")
      .putFile(image).then((value) async{
        String downloadUrl = await value.ref.getDownloadURL();
        _userCollection.doc(_currentUser!.uid).update({
          IMAGE: downloadUrl.toString(),
        });
        _showLoadingIndicatorSubject.sink.add(false);
    });
  }

  dispose(){
    _showLoadingIndicatorSubject.close();
  }
}