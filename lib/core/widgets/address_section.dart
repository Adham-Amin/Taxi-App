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
    var isLight = Theme.of(context).brightness == Brightness.light;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildlabeAddress(text: 'PICKUP', isLight: isLight),
        SizedBox(height: 4.h),
        Text(
          pickupAddress,
          style: AppStyles.textBold16,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 16.h),
        _buildlabeAddress(text: 'DESTINATION', isLight: isLight),
        SizedBox(height: 4.h),
        Text(
          destinationAddress,
          style: AppStyles.textBold16,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Text _buildlabeAddress({required String text, required bool isLight}) {
    return Text(
      text,
      style: AppStyles.textSemiBold12.copyWith(
        color: isLight ? AppColors.darkGrey : AppColors.accent,
        letterSpacing: 1,
      ),
    );
  }
}
