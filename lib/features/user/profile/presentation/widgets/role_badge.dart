import 'package:flutter/material.dart';
import 'package:taxi_app/core/functions/extentions.dart';
import 'package:taxi_app/core/utils/app_colors.dart';
import 'package:taxi_app/core/utils/app_styles.dart';

class RoleBadge extends StatelessWidget {
  const RoleBadge({super.key, required this.role});

  final String role;

  @override
  Widget build(BuildContext context) {
    var isLight = Theme.of(context).brightness == Brightness.light;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: isLight ? AppColors.background : AppColors.darkBlack,
        borderRadius: BorderRadius.circular(60),
        border: Border.all(
          color: isLight
              ? AppColors.mutedSlateGray.withValues(alpha: 0.2)
              : AppColors.grey,
          width: 2,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.person_outlined, color: AppColors.lightGreen),
          8.ws,
          Text(
            role.toUpperCase(),
            style: AppStyles.textBold12.copyWith(
              color: isLight ? AppColors.dark : AppColors.light,
            ),
          ),
        ],
      ),
    );
  }
}
