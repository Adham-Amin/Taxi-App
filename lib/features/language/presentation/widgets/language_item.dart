import 'package:flutter/material.dart';
import 'package:taxi_app/core/utils/app_colors.dart';
import 'package:taxi_app/core/utils/app_styles.dart';

class LanguageItem extends StatelessWidget {
  const LanguageItem({
    super.key,
    this.onTap,
    required this.text,
    required this.value,
    required this.flag,
  });

  final VoidCallback? onTap;
  final String text;
  final bool value;
  final String flag;

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: value
              ? (isLight
                  ? AppColors.lightGreen.withValues(alpha: 0.08)
                  : AppColors.lightGreen.withValues(alpha: 0.1))
              : (isLight ? AppColors.white : AppColors.darkBlack),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: value
                ? AppColors.lightGreen
                : (isLight
                    ? AppColors.mutedSlateGray.withValues(alpha: 0.5)
                    : AppColors.grey),
            width: value ? 2 : 1.5,
          ),
          boxShadow: value
              ? [
                  BoxShadow(
                    color: AppColors.lightGreen.withValues(alpha: 0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 16),
            Expanded(
              child: Text(text, style: AppStyles.textMedium16),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: value ? AppColors.lightGreen : Colors.transparent,
                border: Border.all(
                  color: value
                      ? AppColors.lightGreen
                      : (isLight
                          ? AppColors.mutedSlateGray
                          : AppColors.lightGrey),
                  width: 2,
                ),
              ),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: value ? 1.0 : 0.0,
                child: const Icon(
                  Icons.check,
                  size: 16,
                  color: AppColors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
