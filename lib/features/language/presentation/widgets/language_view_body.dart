import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:taxi_app/core/functions/extentions.dart';
import 'package:taxi_app/core/lang/locale_keys.g.dart';
import 'package:taxi_app/core/utils/app_styles.dart';
import 'package:taxi_app/features/language/presentation/widgets/language_item.dart';

class LanguageViewBody extends StatefulWidget {
  const LanguageViewBody({super.key});

  @override
  State<LanguageViewBody> createState() => _LanguageViewBodyState();
}

class _LanguageViewBodyState extends State<LanguageViewBody>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _headerAnim;
  late final Animation<double> _item1Anim;
  late final Animation<double> _item2Anim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _headerAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
    );
    _item1Anim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 0.6, curve: Curves.easeOut),
    );
    _item2Anim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.4, 0.8, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildAnimatedItem({
    required Animation<double> animation,
    required Widget child,
  }) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.3),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          32.hs,
          FadeTransition(
            opacity: _headerAnim,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(-0.1, 0),
                end: Offset.zero,
              ).animate(_headerAnim),
              child: Text(
                LocaleKeys.select_language.tr(),
                style: AppStyles.textSemiBold18,
              ),
            ),
          ),
          24.hs,
          _buildAnimatedItem(
            animation: _item1Anim,
            child: LanguageItem(
              onTap: () => context.setLocale(const Locale('en')),
              text: LocaleKeys.english.tr(),
              value: context.locale.languageCode == 'en',
              flag: '\u{1F1FA}\u{1F1F8}',
            ),
          ),
          16.hs,
          _buildAnimatedItem(
            animation: _item2Anim,
            child: LanguageItem(
              onTap: () => context.setLocale(const Locale('ar')),
              text: LocaleKeys.arabic.tr(),
              value: context.locale.languageCode == 'ar',
              flag: '\u{1F1F8}\u{1F1E6}',
            ),
          ),
        ],
      ),
    );
  }
}
