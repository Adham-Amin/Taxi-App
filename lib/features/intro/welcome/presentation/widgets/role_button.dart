import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:taxi_app/core/lang/locale_keys.g.dart';
import 'package:taxi_app/core/utils/app_colors.dart';
import 'package:taxi_app/core/utils/app_styles.dart';

class RoleButton extends StatelessWidget {
  const RoleButton({
    super.key,
    required this.title,
    required this.isActive,
    required this.onTap,
  });

  final String title;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isActive
              ? isLight
                    ? AppColors.white
                    : AppColors.darkGrey
              : Colors.transparent,
          border: Border.all(
            color: isActive
                ? AppColors.lightGreen.withValues(alpha: 0.2)
                : Colors.transparent,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: Color(0x19000000),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                    spreadRadius: -2,
                  ),
                ]
              : [],
        ),
        child: Text(
          '${LocaleKeys.continue_as.tr()} $title',
          textAlign: TextAlign.center,
          style: AppStyles.textBold14.copyWith(
            color: isActive
                ? AppColors.lightGreen
                : isLight
                ? AppColors.darkOliveGray
                : AppColors.light,
          ),
        ),
      ),
    );
  }
}
