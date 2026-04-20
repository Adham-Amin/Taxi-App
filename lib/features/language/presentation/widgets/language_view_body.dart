import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:taxi_app/core/functions/extentions.dart';
import 'package:taxi_app/core/utils/app_styles.dart';
import 'package:taxi_app/features/language/presentation/widgets/language_item.dart';

class LanguageViewBody extends StatelessWidget {
  const LanguageViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          32.hs,
          Text('select_language'.tr(), style: AppStyles.textMedium16),
          16.hs,
          LanguageItem(
            onTap: (_) {
              context.setLocale(const Locale('en'));
            },
            text: 'english'.tr(),
            value: context.locale.languageCode == 'en',
          ),
          16.hs,
          LanguageItem(
            onTap: (_) {
              context.setLocale(const Locale('ar'));
            },
            text: 'arabic'.tr(),
            value: context.locale.languageCode == 'ar',
          ),
        ],
      ),
    );
  }
}
