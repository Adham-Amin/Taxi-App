import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taxi_app/core/utils/app_colors.dart';
import 'package:taxi_app/core/utils/app_styles.dart';
import 'package:taxi_app/core/widgets/label_text.dart';

class OfferRouteInfo extends StatelessWidget {
  const OfferRouteInfo({
    super.key,
    required this.pickupAddress,
    required this.destinationAddress,
  });

  final String pickupAddress;
  final String destinationAddress;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildRouteIndicator(),
          SizedBox(width: 12.w),
          Expanded(child: _buildAddresses()),
        ],
      ),
    );
  }

  Widget _buildRouteIndicator() {
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

  Widget _buildAddresses() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const LabelText(text: 'PICKUP'),
        SizedBox(height: 4.h),
        Text(
          pickupAddress,
          style: AppStyles.textMedium14.copyWith(color: AppColors.white),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 16.h),
        const LabelText(text: 'DESTINATION'),
        SizedBox(height: 4.h),
        Text(
          destinationAddress,
          style: AppStyles.textMedium14.copyWith(color: AppColors.white),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
