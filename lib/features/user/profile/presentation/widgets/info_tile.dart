import 'package:flutter/material.dart';
import 'package:taxi_app/core/functions/extentions.dart';
import 'package:taxi_app/core/utils/app_colors.dart';
import 'package:taxi_app/core/utils/app_styles.dart';

class InfoTile extends StatelessWidget {
  const InfoTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    var isLight = Theme.of(context).brightness == Brightness.light;
    return Row(
      children: [
        Icon(icon, color: isLight ? AppColors.lightGrey : AppColors.lightGrey),
        16.ws,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppStyles.textBold12.copyWith(
                color: isLight ? AppColors.lightGrey : AppColors.lightGrey,
              ),
            ),
            4.hs,
            Text(
              subtitle,
              style: AppStyles.textMedium14.copyWith(
                color: isLight ? AppColors.dark : AppColors.light,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
