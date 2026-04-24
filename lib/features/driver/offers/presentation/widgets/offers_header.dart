import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taxi_app/core/utils/app_colors.dart';
import 'package:taxi_app/core/utils/app_styles.dart';

class OffersHeader extends StatelessWidget {
  const OffersHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'LIVE FEED',
          style: AppStyles.textBold12.copyWith(
            color: AppColors.lightGreen,
            letterSpacing: 2,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'Active Requests',
          style: AppStyles.textExtraBold36.copyWith(
            color: Theme.of(context).brightness == Brightness.light
                ? AppColors.dark
                : AppColors.white,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'Real-time offers from passengers in your immediate vicinity. Accept to lock the fare.',
          style: AppStyles.textRegular16.copyWith(color: AppColors.accent),
        ),
      ],
    );
  }
}
