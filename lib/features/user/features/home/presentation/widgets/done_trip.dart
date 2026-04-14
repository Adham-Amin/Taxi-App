import 'package:flutter/material.dart';
import 'package:taxi_app/core/functions/extentions.dart';
import 'package:taxi_app/core/utils/app_colors.dart';
import 'package:taxi_app/core/widgets/custom_button.dart';
import 'package:taxi_app/features/user/features/home/presentation/widgets/trip_completed_card.dart';
import 'package:taxi_app/features/user/features/home/presentation/widgets/trip_completed_header.dart';

class DoneTrip extends StatelessWidget {
  const DoneTrip({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.dark.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Spacer(),
          TripCompletedHeader(),
          32.hs,
          TripCompletedCard(),
          Spacer(),
          CustomButton(title: 'Done', onTap: onTap),
          32.hs,
        ],
      ),
    );
  }
}
