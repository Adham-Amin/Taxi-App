import 'package:flutter/material.dart';
import 'package:taxi_app/features/intro/welcome/presentation/widgets/welcome_view_body.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: WelcomeViewBody());
  }
}
