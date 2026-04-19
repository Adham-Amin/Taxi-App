import 'package:flutter/material.dart';
import 'package:taxi_app/core/functions/extentions.dart';
import 'package:taxi_app/core/utils/app_colors.dart';
import 'package:taxi_app/core/utils/app_styles.dart';

class LocationItem extends StatelessWidget {
  const LocationItem({super.key, required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppStyles.textSemiBold12.copyWith(color: AppColors.accent),
        ),
        4.hs,
        Text(
          value,
          style: AppStyles.textBold16.copyWith(color: AppColors.light),
        ),
      ],
    );
  }
}
