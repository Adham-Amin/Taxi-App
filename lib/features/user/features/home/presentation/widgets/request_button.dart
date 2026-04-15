import 'package:flutter/material.dart';
import 'package:taxi_app/core/functions/extentions.dart';
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
                  hintText: 'Enter amount',
                  controller: priceController,
                ),
              ),
              12.ws,
              Text(
                'EGP',
                style: AppStyles.textExtraBold36.copyWith(
                  color: AppColors.lightGreen,
                ),
              ),
            ],
          ),
          16.hs,
          CustomButton(
            isLoading: isLoading,
            title: 'Request Ride',
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}
