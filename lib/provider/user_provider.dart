import 'package:flutter/material.dart';
import 'package:do_favors/model/user_model.dart';

class UserProvider with ChangeNotifier {
  late UserModel _currentUser;
  UserModel get currentUser => this._currentUser;

  UserProvider(){
    _currentUser = UserModel(
      id: '',
      name: '',
      email: '',
      score: -1,
      photoUrl: '',
    );
  }

  setUser(UserModel user) {
    this._currentUser = user;
    notifyListeners();
  }

  updateUserScore(int newScore){
    this._currentUser.score = newScore;
    notifyListeners();
  }

  updateUserPhotoUrl(String newPhoto){
    this._currentUser.photoUrl = newPhoto;
    notifyListeners();
  }
}