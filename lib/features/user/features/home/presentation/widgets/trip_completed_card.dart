import 'package:flutter/material.dart';
import 'package:taxi_app/core/functions/extentions.dart';
import 'package:taxi_app/core/utils/app_colors.dart';
import 'package:taxi_app/features/user/features/home/data/models/ride_model.dart';
import 'package:taxi_app/features/user/features/home/presentation/widgets/dot_icon.dart';
import 'package:taxi_app/features/user/features/home/presentation/widgets/location_item.dart';
import 'package:taxi_app/features/user/features/home/presentation/widgets/price_section.dart';

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
          SizedBox(
            height: 132,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    4.hs,
                    DotIcon(color: AppColors.red),
                    4.hs,
                    Expanded(
                      child: Container(
                        width: 2,
                        height: 64,
                        color: Colors.white24,
                      ),
                    ),
                    4.hs,
                    DotIcon(color: AppColors.lightGreen),
                    4.hs,
                  ],
                ),
                16.ws,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    LocationItem(
                      title: 'PICKUP',
                      value: trip.pickup.fullAddress,
                    ),
                    LocationItem(
                      title: 'DESTINATION',
                      value: trip.destination.fullAddress,
                    ),
                  ],
                ),
              ],
            ),
          ),
          24.hs,
          PriceSection(price: trip.price.toString()),
        ],
      ),
    );
  }
}
