import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taxi_app/core/functions/extentions.dart';
import 'package:taxi_app/core/utils/app_assets.dart';
import 'package:taxi_app/core/utils/app_colors.dart';
import 'package:taxi_app/core/utils/app_styles.dart';
import 'package:taxi_app/features/auth/presentation/widgets/social_button.dart';

class SocialButtonsRow extends StatelessWidget {
  const SocialButtonsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          spacing: 8.w,
          children: [
            Expanded(child: Divider(thickness: 1.2)),
            Text('Or', style: AppStyles.textRegular14),
            Expanded(child: Divider(thickness: 1.2)),
          ],
        ),
        16.hs,
        SocialButton(
          text: 'Login with Google',
          borderColor: AppColors.darkGrey,
          iconPath: AppAssets.iconsLogosGoogleIcon,
          onPressed: () {},
        ),
        16.hs,
        SocialButton(
          text: 'Login with Facebook',
          iconPath: AppAssets.iconsLogosFacebook,
          onPressed: () {},
          backgroundColor: AppColors.facebookColor,
          textColor: AppColors.white,
        ),
      ],
    );
  }
}
