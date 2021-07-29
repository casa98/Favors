import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String? _id;
  String? get id => _id;

  String? _name;
  String? get name => _name;

  String? _email;
  String? get email => _email;

  int? _score;
  int? get score => _score;

  String? _photourl;
  String? get photoUrl => _photourl;

  void setId(String id) {
    this._id = id;
  }

  void setName(String name) {
    this._name = name;
  }

  void setEmail(String email) {
    this._email = email;
  }

  void setScore(int score) {
    this._score = score;
    // Need to notify so that FAB is shown/hidden
    notifyListeners();
  }

  void updateScore(int newScore) {
    this._score = newScore;
    // Same case as above
    notifyListeners();
  }

  void setPhotoUrl(String photoUrl) {
    this._photourl = photoUrl;
    notifyListeners();
  }

  void updatePhotoUrl(String newPhotoUrl) {
    this._photourl = newPhotoUrl;
    notifyListeners();
  }

  void clear() {
    this._id = null;
    this._name = null;
    this._email = null;
    this._score = null;
    this._photourl = null;
  }
}
