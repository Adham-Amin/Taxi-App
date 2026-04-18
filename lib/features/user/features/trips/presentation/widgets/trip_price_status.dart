import 'package:flutter/material.dart';
import 'package:taxi_app/core/functions/extentions.dart';
import 'package:taxi_app/core/utils/app_colors.dart';
import 'package:taxi_app/core/utils/app_styles.dart';
import 'package:taxi_app/features/user/features/trips/domain/entities/trip_entity.dart';

class TripPriceStatus extends StatelessWidget {
  const TripPriceStatus({super.key, required this.trip});

  final TripEntity trip;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '\$${trip.price}',
          style: AppStyles.textExtraBold18.copyWith(
            color: trip.status == 'canceled'
                ? AppColors.accent
                : trip.status == 'searching'
                ? AppColors.accent
                : AppColors.lightGreen,
          ),
        ),
        4.hs,
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: trip.status == 'canceled'
                ? AppColors.red.withValues(alpha: 0.1)
                : trip.status == 'searching'
                ? AppColors.accent.withValues(alpha: 0.1)
                : AppColors.lightGreen.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            trip.status.toUpperCase(),
            style: AppStyles.textBold12.copyWith(
              color: trip.status == 'canceled'
                  ? AppColors.red
                  : trip.status == 'searching'
                  ? AppColors.accent
                  : AppColors.lightGreen,
            ),
          ),
        ),
      ],
    );
  }
}
