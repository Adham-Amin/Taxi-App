import 'package:flutter/material.dart';
import 'package:taxi_app/core/functions/extentions.dart';
import 'package:taxi_app/core/utils/app_colors.dart';
import 'package:taxi_app/core/widgets/custom_button.dart';
import 'package:taxi_app/features/user/home/data/models/ride_model.dart';
import 'package:taxi_app/features/user/home/presentation/widgets/trip_completed_card.dart';
import 'package:taxi_app/features/user/home/presentation/widgets/trip_completed_header.dart';

class TripDoneOverlay extends StatelessWidget {
  const TripDoneOverlay({
    super.key,
    required this.trip,
    required this.onDone,
  });

  final TripModel trip;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.dark.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const Spacer(),
          const TripCompletedHeader(),
          32.hs,
          TripCompletedCard(trip: trip),
          const Spacer(),
          CustomButton(title: 'Done', onTap: onDone),
          32.hs,
        ],
      ),
    );
  }
}
