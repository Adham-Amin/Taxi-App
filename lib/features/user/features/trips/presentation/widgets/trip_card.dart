import 'package:flutter/material.dart';
import 'package:taxi_app/core/functions/extentions.dart';
import 'package:taxi_app/core/utils/app_colors.dart';
import 'package:taxi_app/features/user/features/trips/domain/entities/trip_entity.dart';
import 'package:taxi_app/features/user/features/trips/presentation/widgets/trip_date.dart';
import 'package:taxi_app/features/user/features/trips/presentation/widgets/trip_header.dart';
import 'package:taxi_app/features/user/features/trips/presentation/widgets/trip_locations.dart';

class TripCard extends StatelessWidget {
  const TripCard({super.key, required this.trip});

  final TripEntity trip;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.darkBlack,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          TripHeader(trip: trip),
          16.hs,
          TripLocations(trip: trip),
          Divider(height: 24, color: AppColors.white.withValues(alpha: 0.08)),
          TripDate(trip: trip),
        ],
      ),
    );
  }
}
