import 'package:flutter/material.dart';

class AppStateNotifier extends ChangeNotifier {

  bool isDarkMode = false;

  void updateTheme(bool isDarkMode) {
    print("isDarkMode? $isDarkMode");
    this.isDarkMode = isDarkMode;
    notifyListeners();
  }
}