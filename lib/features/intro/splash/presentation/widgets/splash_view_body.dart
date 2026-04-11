// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taxi_app/core/routing/app_routes.dart';
import 'package:taxi_app/core/services/shared_preferences_service.dart';
import 'package:taxi_app/core/utils/app_assets.dart';

class SplashViewBody extends StatefulWidget {
  const SplashViewBody({super.key});

  @override
  State<SplashViewBody> createState() => _SplashViewBodyState();
}

class _SplashViewBodyState extends State<SplashViewBody> {
  @override
  initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), checkNavigation);
  }

  void checkNavigation() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final role = user.photoURL ?? "";
      if (role == 'user') {
        context.go(AppRoutes.userMain);
      } else {
        context.go(AppRoutes.driverMain);
      }
      return;
    }

    final seen = Prefs.getBool('SeenOn');
    if (seen) {
      context.go(AppRoutes.welcome);
    } else {
      context.go(AppRoutes.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppAssets.imagesSplashScreen),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Image.asset(AppAssets.imagesLogoSplash, height: 320)],
      ),
    );
  }
}
