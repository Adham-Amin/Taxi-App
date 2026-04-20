import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taxi_app/core/routing/router_generation_config.dart';
import 'package:taxi_app/core/services/custom_observer_bloc.dart';
import 'package:taxi_app/core/services/shared_preferences_service.dart';
import 'package:taxi_app/core/theme/theme_data.dart';
import 'package:taxi_app/core/theme_cubit/theme_cubit.dart';
import 'package:taxi_app/core/theme_cubit/theme_state.dart';
import 'package:taxi_app/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Prefs.init();
  Bloc.observer = CustomObserverBloc();
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const CrazyApp(),
    ),
  );
}

class CrazyApp extends StatelessWidget {
  const CrazyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return ScreenUtilInit(
            designSize: const Size(390, 884),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) {
              return MaterialApp.router(
                locale: context.locale,
                supportedLocales: context.supportedLocales,
                localizationsDelegates: context.localizationDelegates,
                debugShowCheckedModeBanner: false,
                themeMode: state.themeMode,
                theme: AppThemes.lightTheme,
                darkTheme: AppThemes.darkTheme,
                routerConfig: RouterGenerationConfig.router,
              );
            },
          );
        },
      ),
    );
  }
}
