import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxi_app/features/auth/data/models/user_info_model.dart';

abstract class Prefs {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> setUser(UserInfoModel user) async {
    await _prefs?.setString('user', jsonEncode(user.toMap()));
  }

  static UserInfoModel? getUser() {
    final user = _prefs?.getString('user');
    return user != null ? UserInfoModel.fromMap(jsonDecode(user)) : null;
  }

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
