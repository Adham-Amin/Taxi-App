import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taxi_app/core/utils/app_colors.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return GestureDetector(
      onTap: () => context.pop(),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isLight ? AppColors.white : AppColors.grey,
          border: Border.all(color: isLight ? AppColors.light : AppColors.grey),
        ),
        child: const Icon(Icons.arrow_back, color: AppColors.lightGreen),
      ),
    );
  }
}
