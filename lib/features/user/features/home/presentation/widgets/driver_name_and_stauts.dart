import 'package:flutter/material.dart';
import 'package:taxi_app/core/functions/extentions.dart';
import 'package:taxi_app/core/utils/app_colors.dart';
import 'package:taxi_app/core/utils/app_styles.dart';

class DriverNameAndStauts extends StatelessWidget {
  const DriverNameAndStauts({super.key, required this.stauts});

  final String stauts;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Your Driver',
          style: AppStyles.textRegular12.copyWith(color: AppColors.accent),
        ),
        Text('Lio Messi', style: AppStyles.textBold18, maxLines: 1),
        4.hs,
        Text(
          stauts,
          style: AppStyles.textRegular12.copyWith(color: AppColors.lightGreen),
        ),
      ],
    );
  }
}
