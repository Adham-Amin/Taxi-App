import 'package:flutter/material.dart';
import 'package:taxi_app/core/functions/extentions.dart';
import 'package:taxi_app/core/utils/app_colors.dart';
import 'package:taxi_app/core/widgets/route_info.dart';
import 'package:taxi_app/features/user/home/data/models/ride_model.dart';
import 'package:taxi_app/features/user/home/presentation/widgets/price_section.dart';

class TripCompletedCard extends StatelessWidget {
  const TripCompletedCard({super.key, required this.trip});

  final TripModel trip;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.dark.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          RouteInfo(
            pickupAddress: trip.pickup.fullAddress,
            destinationAddress: trip.destination.fullAddress,
          ),
          24.hs,
          PriceSection(price: trip.price.toString()),
        ],
      ),
    );
  }
}
