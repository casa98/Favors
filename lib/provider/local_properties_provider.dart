import 'package:shared_preferences/shared_preferences.dart';

class LocalPropertiesProvider {
  static const DEVICE_TOKEN_SAVED = 'DEVICE_TOKEN_SAVED';

  /// Says if device token is already saved in remote DB
  Future<bool> loadTokenStatus() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.getBool(DEVICE_TOKEN_SAVED) ?? false;
  }

  Future<void> saveStatus() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setBool(DEVICE_TOKEN_SAVED, true);
  }
}
