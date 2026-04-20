import 'package:flutter/material.dart';
import 'package:go_transitions/go_transitions.dart';
import 'package:taxi_app/core/utils/app_colors.dart';
import 'package:taxi_app/core/utils/app_styles.dart';

class AppThemes {
  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.dark,
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        TargetPlatform.android: GoTransitions.slide.toTop.withFade,
        TargetPlatform.iOS: GoTransitions.slide.toTop.withFade,
      },
    ),
    fontFamily: AppStyles.fontFamily,
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: AppStyles.textRegular16.copyWith(
        color: AppColors.accent.withValues(alpha: 0.5),
      ),
      suffixIconColor: AppColors.lightGreen.withValues(alpha: 0.5),
      filled: true,
      fillColor: AppColors.darkBlack,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: AppColors.lightGreen.withValues(alpha: 0.5),
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
    ),
  );
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.white,
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        TargetPlatform.android: GoTransitions.slide.toTop.withFade,
        TargetPlatform.iOS: GoTransitions.slide.toTop.withFade,
      },
    ),

    fontFamily: AppStyles.fontFamily,

    colorScheme: ColorScheme.light(
      primary: AppColors.green,
      secondary: AppColors.lightGreen,
      surface: AppColors.white,
      error: AppColors.red,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.black),
      titleTextStyle: AppStyles.textSemiBold18.copyWith(color: AppColors.black),
    ),

    textTheme: TextTheme(
      bodyLarge: AppStyles.textRegular16.copyWith(color: AppColors.black),
      bodyMedium: AppStyles.textRegular14.copyWith(color: AppColors.darkGrey),
    ),

    inputDecorationTheme: InputDecorationTheme(
      hintStyle: AppStyles.textRegular16.copyWith(color: AppColors.lightGrey),
      suffixIconColor: AppColors.green,

      filled: true,
      fillColor: AppColors.light,

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: AppColors.lightGrey.withValues(alpha: 0.3),
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.green),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.red),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.red),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.green,
        foregroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );
}
