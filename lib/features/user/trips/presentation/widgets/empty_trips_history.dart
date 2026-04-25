import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:taxi_app/core/lang/locale_keys.g.dart';
import 'package:taxi_app/core/utils/app_colors.dart';
import 'package:taxi_app/core/utils/app_styles.dart';

class EmptyTripsHistory extends StatelessWidget {
  const EmptyTripsHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        LocaleKeys.no_trips.tr(),
        style: AppStyles.textMedium14.copyWith(color: AppColors.accent),
      ),
    );
  }
}
