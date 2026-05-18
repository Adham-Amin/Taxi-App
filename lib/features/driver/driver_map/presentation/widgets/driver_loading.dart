import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:taxi_app/core/utils/app_assets.dart';

class DriverLoading extends StatelessWidget {
  const DriverLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(child: Lottie.asset(AppAssets.lottieMercedes));
  }
}
