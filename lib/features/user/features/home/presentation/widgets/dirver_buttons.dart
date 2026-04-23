import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:taxi_app/core/functions/extentions.dart';
import 'package:taxi_app/core/lang/locale_keys.g.dart';
import 'package:taxi_app/core/utils/app_colors.dart';
import 'package:taxi_app/core/widgets/custom_button.dart';
import 'package:taxi_app/features/user/features/home/data/models/ride_model.dart';
import 'package:url_launcher/url_launcher.dart';

class DirverButtons extends StatelessWidget {
  const DirverButtons({super.key, required this.trip});

  final TripModel trip;

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return Row(
      children: [
        Expanded(
          child: CustomButton(
            title: LocaleKeys.message.tr(),
            onTap: () {},
            colorText: isLight ? AppColors.dark : AppColors.light,
            backgroundColor: isLight ? AppColors.offWhite : AppColors.darkGrey,
            shadeColor: Colors.transparent,
            icon: Icon(Icons.message_outlined, color: AppColors.lightGreen),
          ),
        ),
        12.ws,
        Expanded(
          child: CustomButton(
            title: LocaleKeys.call.tr(),
            onTap: () {
              launchUrl(Uri.parse('tel:${trip.driver.phone}'));
            },
            colorText: isLight ? AppColors.dark : AppColors.light,
            backgroundColor: isLight ? AppColors.offWhite : AppColors.darkGrey,
            shadeColor: Colors.transparent,
            icon: Icon(Icons.call_outlined, color: AppColors.lightGreen),
          ),
        ),
      ],
    );
  }
}
