import 'package:flutter/material.dart';
import 'package:taxi_app/core/utils/app_colors.dart';
import 'package:taxi_app/core/utils/app_styles.dart';
import 'package:taxi_app/features/user/features/trips/domain/entities/trip_entity.dart';

class DriverInfo extends StatelessWidget {
  const DriverInfo({super.key, required this.trip});

  final TripEntity trip;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          trip.status == 'canceled' ? 'No Driver' : 'Driver',
          style: AppStyles.textSemiBold12.copyWith(color: AppColors.accent),
        ),
        Text(
          trip.status == 'canceled'
              ? 'Self-Cancelled'
              : trip.status == 'searching'
              ? 'Searching'
              : trip.driverName,
          style: AppStyles.textBold14,
        ),
      ],
    );
  }
}
