import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taxi_app/core/utils/app_colors.dart';
import 'package:taxi_app/core/utils/app_styles.dart';

class AddressSection extends StatelessWidget {
  const AddressSection({
    super.key,
    required this.pickupAddress,
    required this.destinationAddress,
  });

  final String pickupAddress;
  final String destinationAddress;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildlabeAddress(text: 'PICKUP'),
        SizedBox(height: 4.h),
        Text(
          pickupAddress,
          style: AppStyles.textBold16.copyWith(color: AppColors.white),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 16.h),
        _buildlabeAddress(text: 'DESTINATION'),
        SizedBox(height: 4.h),
        Text(
          destinationAddress,
          style: AppStyles.textBold16.copyWith(color: AppColors.white),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Text _buildlabeAddress({required String text}) {
    return Text(
      text,
      style: AppStyles.textSemiBold12.copyWith(
        color: AppColors.accent,
        letterSpacing: 1,
      ),
    );
  }
}
