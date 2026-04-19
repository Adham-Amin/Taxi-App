import 'package:flutter/material.dart';
import 'package:taxi_app/core/functions/extentions.dart';
import 'package:taxi_app/core/utils/app_colors.dart';
import 'package:taxi_app/core/utils/app_styles.dart';

class ButtonTile extends StatelessWidget {
  const ButtonTile({
    super.key,
    required this.onTap,
    required this.icon,
    required this.title,
  });

  final VoidCallback onTap;
  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: AppColors.lightGrey),
          8.ws,
          Text(
            title,
            style: AppStyles.textMedium16.copyWith(color: AppColors.light),
          ),
          const Spacer(),
          Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.lightGreen),
        ],
      ),
    );
  }
}
