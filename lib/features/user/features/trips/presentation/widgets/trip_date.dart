import 'package:flutter/material.dart';
import 'package:taxi_app/core/functions/extentions.dart';
import 'package:taxi_app/core/utils/app_colors.dart';
import 'package:taxi_app/core/utils/app_styles.dart';
import 'package:taxi_app/features/user/features/trips/domain/entities/trip_entity.dart';

class TripDate extends StatelessWidget {
  const TripDate({super.key, required this.trip});

  final TripEntity trip;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        8.ws,
        Icon(Icons.calendar_month, color: AppColors.accent),
        8.ws,
        Text(
          trip.date,
          style: AppStyles.textSemiBold12.copyWith(color: AppColors.accent),
        ),
      ],
    );
  }
}
