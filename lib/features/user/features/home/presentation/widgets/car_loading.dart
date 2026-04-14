import 'package:flutter/material.dart';
import 'package:taxi_app/core/utils/app_colors.dart';

class CarLoading extends StatelessWidget {
  const CarLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.lightGreen.withValues(alpha: 0.15),
      ),
      child: Center(
        child: Container(
          width: 70,
          height: 70,
          decoration: const BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.directions_car,
            color: Colors.black,
            size: 30,
          ),
        ),
      ),
    );
  }
}
