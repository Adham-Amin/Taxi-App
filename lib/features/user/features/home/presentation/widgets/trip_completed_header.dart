import 'package:flutter/material.dart';
import 'package:taxi_app/core/functions/extentions.dart';
import 'package:taxi_app/core/utils/app_colors.dart';
import 'package:taxi_app/core/utils/app_styles.dart';

class TripCompletedHeader extends StatelessWidget {
  const TripCompletedHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.green.withValues(alpha: 0.2),
          ),
          child: const Center(
            child: Icon(Icons.check, color: AppColors.lightGreen, size: 40),
          ),
        ),
        24.hs,
        Text(
          'Trip Completed',
          style: AppStyles.textExtraBold30.copyWith(color: AppColors.lightGrey),
        ),
        8.hs,
        Text(
          'Hope you enjoyed the ride with \n Crazy Taxi.',
          textAlign: TextAlign.center,
          style: AppStyles.textRegular18.copyWith(color: AppColors.accent),
        ),
      ],
    );
  }
}
