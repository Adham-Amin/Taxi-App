import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taxi_app/core/utils/app_colors.dart';

class RouteIndicator extends StatelessWidget {
  const RouteIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 12.w,
          height: 12.w,
          decoration: const BoxDecoration(
            color: AppColors.lightGreen,
            shape: BoxShape.circle,
          ),
        ),
        Expanded(
          child: Container(
            width: 2,
            margin: EdgeInsets.symmetric(vertical: 4.h),
            color: AppColors.lightGrey.withValues(alpha: 0.3),
          ),
        ),
        Container(
          width: 12.w,
          height: 12.w,
          decoration: const BoxDecoration(
            color: AppColors.lightGrey,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}
