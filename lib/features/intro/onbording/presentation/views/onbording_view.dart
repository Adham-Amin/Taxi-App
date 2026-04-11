import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taxi_app/core/routing/app_routes.dart';
import 'package:taxi_app/core/services/shared_preferences_service.dart';
import 'package:taxi_app/core/utils/app_colors.dart';
import 'package:taxi_app/core/utils/app_styles.dart';
import 'package:taxi_app/features/intro/onbording/presentation/widgets/onbording_view_body.dart';

class OnbordingView extends StatelessWidget {
  const OnbordingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          TextButton(
            onPressed: () async {
              context.go(AppRoutes.welcome);
              await Prefs.setBool('SeenOn', true);
            },
            child: Text(
              'Skip',
              style: AppStyles.textSemiBold16.copyWith(color: AppColors.accent),
            ),
          ),
        ],
      ),
      body: SafeArea(child: OnbordingViewBody()),
    );
  }
}
