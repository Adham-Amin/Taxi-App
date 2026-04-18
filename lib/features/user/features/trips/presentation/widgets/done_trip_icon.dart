import 'package:flutter/material.dart';
import 'package:taxi_app/core/utils/app_colors.dart';
import 'package:taxi_app/features/user/features/trips/domain/entities/trip_entity.dart';

class DoneTripIcon extends StatelessWidget {
  const DoneTripIcon({super.key, required this.trip});

  final TripEntity trip;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 24,
      backgroundColor: trip.status == 'canceled'
          ? AppColors.darkGrey
          : trip.status == 'searching'
          ? AppColors.accent.withValues(alpha: 0.1)
          : AppColors.darkGreen,
      child: CircleAvatar(
        radius: 12,
        backgroundColor: trip.status == 'canceled'
            ? AppColors.red
            : trip.status == 'searching'
            ? AppColors.accent
            : AppColors.lightGreen,
        child: Icon(
          trip.status == 'canceled'
              ? Icons.close
              : trip.status == 'searching'
              ? Icons.search
              : Icons.check,
          color: trip.status == 'canceled'
              ? AppColors.white
              : AppColors.darkGreen,
          size: 16,
        ),
      ),
    );
  }
}
