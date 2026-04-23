import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:taxi_app/core/lang/locale_keys.g.dart';
import 'package:taxi_app/core/utils/app_colors.dart';
import 'package:taxi_app/core/utils/app_styles.dart';

class PriceSection extends StatelessWidget {
  const PriceSection({super.key, required this.price});

  final String price;

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isLight ? AppColors.offWhite : AppColors.darkGrey,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            LocaleKeys.final_price.tr(),
            style: AppStyles.textSemiBold12.copyWith(
              color: isLight ? AppColors.dark : AppColors.accent,
              letterSpacing: 1,
            ),
          ),
          Text(
            '\$$price',
            style: AppStyles.textExtraBold24.copyWith(
              color: AppColors.lightGreen,
            ),
          ),
        ],
      ),
    );
  }
}
