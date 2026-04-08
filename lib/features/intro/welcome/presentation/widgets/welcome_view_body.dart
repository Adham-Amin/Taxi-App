import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:svg_flutter/svg_flutter.dart';
import 'package:taxi_app/core/functions/extentions.dart';
import 'package:taxi_app/core/routing/app_routes.dart';
import 'package:taxi_app/core/utils/app_assets.dart';
import 'package:taxi_app/core/utils/app_colors.dart';
import 'package:taxi_app/core/utils/app_styles.dart';
import 'package:taxi_app/core/widgets/custom_button.dart';
import 'package:taxi_app/core/widgets/custom_rich_text.dart';
import 'package:taxi_app/features/intro/welcome/data/model/user_type_enum.dart';
import 'package:taxi_app/features/intro/welcome/presentation/widgets/role_selector.dart';

class WelcomeViewBody extends StatefulWidget {
  const WelcomeViewBody({super.key});

  @override
  State<WelcomeViewBody> createState() => _WelcomeViewBodyState();
}

class _WelcomeViewBodyState extends State<WelcomeViewBody> {
  UserTypeEnum role = UserTypeEnum.user;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          SvgPicture.asset(AppAssets.svgsLogo),
          24.hs,
          Text(
            'Crazy Taxi',
            style: AppStyles.textExtraBold36.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          12.hs,
          Text(
            'Experience the next generation of peer-to-peer urban mobility.',
            style: AppStyles.textMedium16,
            textAlign: TextAlign.center,
          ),
          48.hs,
          RoleSelector(
            onTap: (role) {
              setState(() {
                this.role = role;
              });
            },
          ),
          32.hs,
          CustomButton(
            title: 'Login',
            onTap: () => context.push(AppRoutes.login),
          ),
          16.hs,
          CustomButton(
            title: 'Register',
            backgroundColor: AppColors.darkGrey,
            shadeColor: Colors.transparent,
            colorText: AppColors.lightGrey,
            onTap: () {
              role == UserTypeEnum.driver
                  ? context.push(AppRoutes.driverRegister)
                  : context.push(AppRoutes.userRegister);
            },
          ),
          Spacer(),
          CustomRichText(
            text: 'By continuing you agree to our ',
            linkText: 'Terms & Privacy Policy',
            onTap: () {},
          ),
          32.hs,
        ],
      ),
    );
  }
}
