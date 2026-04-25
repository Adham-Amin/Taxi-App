import 'package:flutter/material.dart';
import 'package:taxi_app/core/functions/extentions.dart';
import 'package:taxi_app/core/utils/app_colors.dart';
import 'package:taxi_app/core/widgets/route_info.dart';
import 'package:taxi_app/features/user/features/trips/domain/entities/trip_entity.dart';
import 'package:taxi_app/features/user/features/trips/presentation/widgets/trip_date.dart';
import 'package:taxi_app/features/user/features/trips/presentation/widgets/trip_header.dart';

class TripCard extends StatelessWidget {
  const TripCard({super.key, required this.trip, this.isDriver});

  final TripEntity trip;
  final bool? isDriver;

  @override
  Widget build(BuildContext context) {
    var isLight = Theme.of(context).brightness == Brightness.light;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isLight ? AppColors.white : AppColors.darkBlack,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isLight
            ? [
                BoxShadow(
                  color: AppColors.mutedSlateGray.withValues(alpha: 0.2),
                  blurRadius: 10,

                  offset: const Offset(0, 4),
                ),
              ]
            : [],
        border: isLight
            ? Border.all(color: AppColors.mutedSlateGray.withValues(alpha: 0.2))
            : null,
      ),
      child: Column(
        children: [
          TripHeader(trip: trip, isDriver: isDriver),
          16.hs,
          RouteInfo(
            pickupAddress: trip.originAddress,
            destinationAddress: trip.destinationAddress,
          ),
          // TripLocations(trip: trip),
          Divider(
            height: 24,
            color: isLight
                ? AppColors.black.withValues(alpha: 0.1)
                : AppColors.white.withValues(alpha: 0.08),
          ),
          TripDate(trip: trip),
        ],
      ),
    );
  }
}
