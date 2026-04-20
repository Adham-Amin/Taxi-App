import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxi_app/core/services/shared_preferences_service.dart';

import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState(themeMode: ThemeMode.dark)) {
    loadTheme();
  }

  static const String _key = 'isDark';

  Future<void> loadTheme() async {
    final isDark = Prefs.getBool(_key);

    emit(ThemeState(themeMode: isDark ? ThemeMode.dark : ThemeMode.light));
  }

  Future<void> toggleTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, isDark);

    emit(ThemeState(themeMode: isDark ? ThemeMode.dark : ThemeMode.light));
  }

  void switchTheme() {
    final isDark = state.themeMode == ThemeMode.dark;
    toggleTheme(!isDark);
  }
}
