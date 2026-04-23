import 'package:easy_localization/easy_localization.dart';
import 'package:taxi_app/core/lang/locale_keys.g.dart';

abstract class Validators {
  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) {
      return LocaleKeys.enter_your_full_name.tr();
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return LocaleKeys.enter_your_email.tr();
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return LocaleKeys.invalid_email.tr();
    }
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty || value.length < 11) {
      return LocaleKeys.enter_your_phone_number.tr();
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.trim().isEmpty) {
      return LocaleKeys.enter_your_password.tr();
    }

    final errors = <String>[];

    if (value.length < 8) {
      errors.add("• ${LocaleKeys.password_length.tr()}");
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      errors.add("• ${LocaleKeys.password_uppercase.tr()}");
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      errors.add("• ${LocaleKeys.password_lowercase.tr()}");
    }
    if (!RegExp(r'\d').hasMatch(value)) {
      errors.add("• ${LocaleKeys.password_number.tr()}");
    }
    if (!RegExp(r'[!@#\$&*~%^()\-_+=<>?/.,]').hasMatch(value)) {
      errors.add("• ${LocaleKeys.password_special_character.tr()}");
    }

    if (errors.isEmpty) return null;
    return errors.join('\n');
  }
}
