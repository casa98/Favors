import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStateNotifier extends ChangeNotifier {

  static const key = "theme";
  SharedPreferences _pref;
  bool _isDarkMode;
  bool get isDarkMode => _isDarkMode;

  AppStateNotifier(){
    _isDarkMode = false;
    loadTheme();
  }

  void loadTheme() {
    _loadFromPrefs();
  }

  void updateTheme(bool isDarkMode) {
    this._isDarkMode = isDarkMode;
    _saveToPrefs();
    notifyListeners();
  }

  _initPrefs() async {
    if(_pref == null)
      _pref  = await SharedPreferences.getInstance();
  }

  _loadFromPrefs() async {
    await _initPrefs();
    _isDarkMode = _pref.getBool(key) ?? false;
    notifyListeners();
  }

  _saveToPrefs() async {
    await _initPrefs();
    _pref.setBool(key, _isDarkMode);
  }
}