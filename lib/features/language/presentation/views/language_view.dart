import 'package:flutter/material.dart';
import 'package:taxi_app/core/widgets/custom_back_button.dart';
import 'package:taxi_app/features/language/presentation/widgets/language_view_body.dart';

class LanguageView extends StatelessWidget {
  const LanguageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Center(child: CustomBackButton()),
        scrolledUnderElevation: 0,
        title: Text('Language'),
      ),
      body: SafeArea(child: LanguageViewBody()),
    );
  }
}
