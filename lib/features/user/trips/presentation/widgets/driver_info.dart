import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:taxi_app/core/lang/locale_keys.g.dart';
import 'package:taxi_app/core/utils/app_colors.dart';
import 'package:taxi_app/core/utils/app_styles.dart';
import 'package:taxi_app/features/user/trips/domain/entities/trip_entity.dart';

class DriverInfo extends StatelessWidget {
  const DriverInfo({super.key, required this.trip, this.isDriver});

  final TripEntity trip;
  final bool? isDriver;

  @override
  Widget build(BuildContext context) {
    var isLight = Theme.of(context).brightness == Brightness.light;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isDriver == true
              ? LocaleKeys.user.tr()
              : trip.status == 'canceled'
              ? LocaleKeys.no_driver.tr()
              : LocaleKeys.driver.tr(),
          style: AppStyles.textSemiBold12.copyWith(
            color: isLight ? AppColors.slateGray : AppColors.accent,
          ),
        ),
        Text(
          isDriver == true
              ? trip.userName
              : trip.status == 'canceled'
              ? LocaleKeys.self_cancelled.tr()
              : trip.status == 'searching'
              ? LocaleKeys.searching.tr()
              : trip.driverName,
          style: AppStyles.textBold14,
        ),
      ],
    );
  }
}
