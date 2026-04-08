import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:taxi_app/core/utils/app_colors.dart';
import 'package:taxi_app/core/utils/app_styles.dart';

class CustomRichText extends StatelessWidget {
  final String text;
  final String linkText;
  final VoidCallback onTap;

  const CustomRichText({
    super.key,
    required this.text,
    required this.linkText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: text,
        style: AppStyles.textRegular12,
        children: [
          TextSpan(
            text: ' $linkText',
            style: AppStyles.textMedium12.copyWith(color: AppColors.lightGreen),
            recognizer: TapGestureRecognizer()..onTap = onTap,
          ),
        ],
      ),
    );
  }
}
