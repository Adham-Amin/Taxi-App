import 'package:shared_preferences/shared_preferences.dart';

abstract class Prefs {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // static Future<void> setUser(UserEntity user) async {
  //   await _prefs?.setString('user', jsonEncode(user.toJson()));
  // }

  // static UserEntity? getUser() {
  //   final user = _prefs?.getString('user');
  //   return user != null ? UserEntity.fromJson(jsonDecode(user)) : null;
  // }

  static Future<void> clearUserData() async {
    await _prefs?.remove('user');
  }

  static bool getBool(String key, {bool defaultValue = false}) {
    return _prefs?.getBool(key) ?? defaultValue;
  }

  static Future<void> setBool(String key, bool value) async {
    await _prefs?.setBool(key, value);
  }
}
