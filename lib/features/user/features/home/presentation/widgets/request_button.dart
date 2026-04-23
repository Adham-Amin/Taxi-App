import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:taxi_app/core/functions/extentions.dart';
import 'package:taxi_app/core/lang/locale_keys.g.dart';
import 'package:taxi_app/core/utils/app_colors.dart';
import 'package:taxi_app/core/utils/app_styles.dart';
import 'package:taxi_app/core/widgets/custom_button.dart';
import 'package:taxi_app/core/widgets/custom_text_form_field.dart';

class RequestButton extends StatelessWidget {
  const RequestButton({
    super.key,
    required this.onTap,
    required this.priceController,
    required this.isLoading,
  });

  final VoidCallback onTap;
  final bool isLoading;
  final TextEditingController priceController;

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.dark.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.local_taxi_outlined,
                size: 32,
                color: AppColors.lightGreen,
              ),
              12.ws,
              Expanded(
                child: CustomTextFormField(
                  hintText: LocaleKeys.enter_amount.tr(),
                  controller: priceController,
                ),
              ),
              12.ws,
              Text(
                LocaleKeys.egp.tr(),
                style: AppStyles.textExtraBold36.copyWith(
                  color: AppColors.lightGreen,
                ),
              ),
            ],
          ),
          16.hs,
          CustomButton(
            isLoading: isLoading,
            icon: Icon(
              Icons.speed_sharp,
              color: isLight ? AppColors.white : AppColors.dark,
            ),
            title: LocaleKeys.request_ride.tr(),
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}
