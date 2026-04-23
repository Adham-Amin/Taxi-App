import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taxi_app/core/functions/extentions.dart';
import 'package:taxi_app/core/lang/locale_keys.g.dart';
import 'package:taxi_app/core/routing/app_routes.dart';
import 'package:taxi_app/core/services/shared_preferences_service.dart';
import 'package:taxi_app/core/utils/app_assets.dart';
import 'package:taxi_app/core/utils/app_colors.dart';
import 'package:taxi_app/core/utils/app_styles.dart';
import 'package:taxi_app/core/widgets/custom_button.dart';

class OnbordingViewBody extends StatelessWidget {
  const OnbordingViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(AppAssets.imagesOnbording, height: 342),
          48.hs,
          Text(
            LocaleKeys.onboard_title.tr(),
            textAlign: TextAlign.center,
            style: AppStyles.textExtraBold32,
          ),
          16.hs,
          Text(
            LocaleKeys.onboard_sub.tr(),
            style: AppStyles.textRegular16.copyWith(
              color: isLight ? AppColors.slateGray : AppColors.accent,
            ),
            textAlign: TextAlign.center,
          ),
          110.hs,
          CustomButton(
            title: LocaleKeys.get_started.tr(),
            onTap: () async {
              context.go(AppRoutes.welcome);
              await Prefs.setBool('SeenOn', true);
            },
          ),
        ],
      ),
    );
  }
}
