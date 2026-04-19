import 'package:flutter/material.dart';
import 'package:taxi_app/core/utils/app_colors.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(height: 24, color: AppColors.white.withValues(alpha: 0.08));
  }
}
