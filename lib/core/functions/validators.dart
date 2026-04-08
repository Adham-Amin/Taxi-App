abstract class Validators {
  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter your full name";
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter your email";
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return "Please enter a valid email address";
    }
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty || value.length < 11) {
      return "Please enter valid phone number";
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter your password";
    }

    final errors = <String>[];

    if (value.length < 8) {
      errors.add("• Must be at least 8 characters long");
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      errors.add("• Must contain at least one uppercase letter");
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      errors.add("• Must contain at least one lowercase letter");
    }
    if (!RegExp(r'\d').hasMatch(value)) {
      errors.add("• Must contain at least one number");
    }
    if (!RegExp(r'[!@#\$&*~%^()\-_+=<>?/.,]').hasMatch(value)) {
      errors.add("• Must contain at least one special character");
    }

    if (errors.isEmpty) return null;
    return errors.join('\n');
  }
}
