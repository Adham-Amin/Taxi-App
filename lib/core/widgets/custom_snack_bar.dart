import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';

Future<void> customSnackBar({
  required BuildContext context,
  required String message,
  required AnimatedSnackBarType type,
}) async {
  AnimatedSnackBar.material(
    message,
    type: type,
    duration: const Duration(seconds: 2),
  ).show(context);
}
