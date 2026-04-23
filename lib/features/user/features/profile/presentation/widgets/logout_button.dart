import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taxi_app/core/lang/locale_keys.g.dart';
import 'package:taxi_app/core/routing/app_routes.dart';
import 'package:taxi_app/core/services/shared_preferences_service.dart';
import 'package:taxi_app/core/utils/app_colors.dart';
import 'package:taxi_app/core/widgets/custom_button.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      onTap: () async {
        context.go(AppRoutes.welcome);
        await Prefs.clearUserData();
        await FirebaseAuth.instance.signOut();
      },
      title: LocaleKeys.logout.tr(),
      colorText: AppColors.lightRed,
      backgroundColor: AppColors.lightRed.withValues(alpha: 0.1),
      shadeColor: Colors.transparent,
      icon: Icon(Icons.logout_outlined, color: AppColors.lightRed),
    );
  }
}
