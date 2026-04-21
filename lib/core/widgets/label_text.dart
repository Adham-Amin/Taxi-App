import 'package:flutter/material.dart';
import 'package:taxi_app/core/utils/app_colors.dart';
import 'package:taxi_app/core/utils/app_styles.dart';

class LabelText extends StatelessWidget {
  const LabelText({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final isLiaght = Theme.of(context).brightness == Brightness.light;
    return Text(
      text,
      style: AppStyles.textRegular10.copyWith(
        color: isLiaght ? AppColors.darkSlateGray : AppColors.accent,
        letterSpacing: 2,
      ),
    );
  }
}
