import 'package:flutter/material.dart';
import 'package:taxi_app/core/functions/extentions.dart';
import 'package:taxi_app/core/utils/app_colors.dart';
import 'package:taxi_app/core/utils/app_styles.dart';
import 'package:taxi_app/features/user/trips/domain/entities/trip_entity.dart';

class TripDate extends StatelessWidget {
  const TripDate({super.key, required this.trip});

  final TripEntity trip;

  @override
  Widget build(BuildContext context) {
    var isLight = Theme.of(context).brightness == Brightness.light;
    return Row(
      children: [
        Icon(
          Icons.calendar_month,
          color: isLight ? AppColors.dark : AppColors.accent,
        ),
        8.ws,
        Text(
          trip.date,
          style: AppStyles.textSemiBold12.copyWith(
            color: isLight ? AppColors.dark : AppColors.accent,
          ),
        ),
      ],
    );
  }
}
