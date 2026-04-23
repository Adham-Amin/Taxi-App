import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:svg_flutter/svg.dart';
import 'package:taxi_app/core/functions/extentions.dart';
import 'package:taxi_app/core/lang/locale_keys.g.dart';
import 'package:taxi_app/core/utils/app_assets.dart';
import 'package:taxi_app/core/utils/app_colors.dart';
import 'package:taxi_app/core/utils/app_styles.dart';
import 'package:taxi_app/features/auth/presentation/widgets/login_form.dart';
import 'package:taxi_app/features/auth/presentation/widgets/social_buttons_row.dart';

class LoginViewBody extends StatelessWidget {
  const LoginViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          32.hs,
          SvgPicture.asset(AppAssets.svgsLogo),
          24.hs,
          Text('Crazy Taxi', style: AppStyles.textExtraBold36),
          12.hs,
          Text(
            LocaleKeys.welcome_back.tr(),
            style: AppStyles.textMedium16.copyWith(
              color: isLight ? AppColors.darkSlateGray : AppColors.accent,
            ),
            textAlign: TextAlign.center,
          ),
          48.hs,
          LoginForm(),
          16.hs,
          SocialButtonsRow(),
          32.hs,
        ],
      ),
    );
  }
}
