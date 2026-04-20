import 'package:flutter/material.dart';
import 'package:taxi_app/core/utils/app_colors.dart';
import 'package:taxi_app/core/utils/app_styles.dart';

class LanguageItem extends StatelessWidget {
  const LanguageItem({
    super.key,
    this.onTap,
    required this.text,
    required this.value,
  });

  final Function(bool?)? onTap;
  final String text;
  final bool value;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkBlack,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.grey, width: 2),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Checkbox(
          value: value,
          onChanged: onTap,
          activeColor: AppColors.lightGreen,
        ),
        title: Text(text, style: AppStyles.textMedium16),
      ),
    );
  }
}
