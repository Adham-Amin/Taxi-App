import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:taxi_app/core/functions/extentions.dart';
import 'package:taxi_app/core/lang/locale_keys.g.dart';
import 'package:taxi_app/core/utils/app_colors.dart';
import 'package:taxi_app/core/utils/app_styles.dart';
import 'package:taxi_app/core/widgets/custom_button.dart';
import 'package:taxi_app/core/widgets/custom_text_form_field.dart';

class RequestButton extends StatefulWidget {
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
  State<RequestButton> createState() => _RequestButtonState();
}

class _RequestButtonState extends State<RequestButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
      lowerBound: 0.95,
      upperBound: 1.0,
    )..repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var isLight = Theme.of(context).brightness == Brightness.light;
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
                  keyboardType: TextInputType.number,
                  hintText: LocaleKeys.enter_amount.tr(),
                  controller: widget.priceController,
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

          ScaleTransition(
            scale: widget.isLoading ? AlwaysStoppedAnimation(1) : _controller,
            child: CustomButton(
              isLoading: widget.isLoading,
              icon: Icon(
                Icons.speed_sharp,
                color: isLight ? AppColors.white : AppColors.dark,
              ),
              title: LocaleKeys.request_ride.tr(),
              onTap: widget.onTap,
            ),
          ),
        ],
      ),
    );
  }
}
