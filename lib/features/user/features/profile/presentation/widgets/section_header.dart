import 'package:flutter/material.dart';
import 'package:taxi_app/core/utils/app_colors.dart';
import 'package:taxi_app/core/utils/app_styles.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.onEdit});

  final String title;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppStyles.textBold12.copyWith(color: AppColors.lightGrey),
        ),
        if (onEdit != null)
          GestureDetector(
            onTap: onEdit,
            child: Text(
              'Edit',
              style: AppStyles.textBold14.copyWith(color: AppColors.lightGreen),
            ),
          ),
      ],
    );
  }
}
