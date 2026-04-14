import 'package:flutter/material.dart';
import 'package:taxi_app/core/utils/app_colors.dart';
import 'package:taxi_app/core/utils/app_styles.dart';

class PriceSection extends StatelessWidget {
  const PriceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkGrey,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'FINAL PRICE',
            style: AppStyles.textSemiBold12.copyWith(color: AppColors.accent),
          ),
          Text(
            '\$42.50',
            style: AppStyles.textExtraBold24.copyWith(
              color: AppColors.lightGreen,
            ),
          ),
        ],
      ),
    );
  }
}
