import 'dart:async';

import 'package:do_favors/services/auth.dart';

class LoginController {
  final _showLoadingIndicator = StreamController<bool>();
  Stream<bool> get showLoadingIndicator => _showLoadingIndicator.stream;

  final _displayMessage = StreamController<String>();
  Stream<String> get displayMessage => _displayMessage.stream;

  void login({email: String, password: String}) {
    _showLoadingIndicator.add(true);
    AuthService().signInWithEmailAndPassword(email, password).then((value) {
      //_showLoadingIndicator.add(false); // See lib/wrapper.dart
    }).catchError((error) {
      _showLoadingIndicator.add(false);
      _displayMessage.add(error.message);
    });
  }

  void clear() {
    _showLoadingIndicator.close();
    _displayMessage.close();
  }
}
