import 'package:flutter/material.dart';
import 'package:taxi_app/core/functions/extentions.dart';
import 'package:taxi_app/core/utils/app_colors.dart';

class LocationIconsColumn extends StatelessWidget {
  const LocationIconsColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        24.hs,
        Icon(Icons.circle, color: AppColors.white, size: 16),
        4.hs,
        Container(height: 40, width: 2, color: AppColors.lightGreen),
        4.hs,
        Icon(Icons.location_on, color: AppColors.red),
      ],
    );
  }
}
