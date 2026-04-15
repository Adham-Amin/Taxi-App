import 'package:flutter/material.dart';
import 'package:taxi_app/core/functions/extentions.dart';
import 'package:taxi_app/core/utils/app_colors.dart';
import 'package:taxi_app/core/utils/app_styles.dart';
import 'package:taxi_app/features/user/features/home/data/models/ride_model.dart';

class CarInfo extends StatelessWidget {
  const CarInfo({super.key, required this.trip});

  final TripModel trip;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.lightGreen.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.local_taxi, color: AppColors.lightGreen, size: 16),
        ),
        8.hs,
        Text(
          '${trip.driver.carModel} • ${trip.driver.carColor}',
          style: AppStyles.textBold14.copyWith(color: AppColors.white),
        ),
        2.hs,
        Text(
          trip.driver.carPlateNumber,
          style: AppStyles.textRegular12.copyWith(color: AppColors.accent),
        ),
      ],
    );
  }
}
