import 'package:flutter/material.dart';
import 'package:taxi_app/core/utils/app_styles.dart';

class CustomError extends StatelessWidget {
  const CustomError({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(message, style: AppStyles.textRegular14));
  }
}
