import 'package:flutter/material.dart';
import 'package:taxi_app/core/functions/extentions.dart';
import 'package:taxi_app/core/utils/app_colors.dart';
import 'package:taxi_app/features/user/home/data/models/ride_model.dart';
import 'package:taxi_app/features/user/home/presentation/widgets/car_info.dart';
import 'package:taxi_app/features/user/home/presentation/widgets/dirver_buttons.dart';
import 'package:taxi_app/features/user/home/presentation/widgets/driver_image.dart';
import 'package:taxi_app/features/user/home/presentation/widgets/driver_name_and_stauts.dart';

class DriverInfo extends StatelessWidget {
  const DriverInfo({super.key, required this.trip});

  final TripModel trip;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 32,
      left: 24,
      right: 24,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.dark.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            Row(
              children: [
                DriverImage(trip: trip),
                16.ws,
                Expanded(child: DriverNameAndStauts(trip: trip)),
                CarInfo(trip: trip),
              ],
            ),
            Divider(height: 24, color: AppColors.white.withValues(alpha: 0.08)),
            DirverButtons(trip: trip),
          ],
        ),
      ),
    );
  }
}
