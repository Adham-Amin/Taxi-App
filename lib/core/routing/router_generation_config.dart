import 'package:go_router/go_router.dart';
import 'package:taxi_app/core/routing/app_routes.dart';
import 'package:taxi_app/features/auth/presentation/pages/login_view.dart';
import 'package:taxi_app/features/auth/presentation/pages/register_view.dart';
import 'package:taxi_app/features/driver/main/driver_main_view.dart';
import 'package:taxi_app/features/intro/onbording/presentation/views/onbording_view.dart';
import 'package:taxi_app/features/intro/splash/presentation/views/splash_view.dart';
import 'package:taxi_app/features/intro/welcome/presentation/views/welcome_view.dart';
import 'package:taxi_app/features/language/presentation/views/language_view.dart';
import 'package:taxi_app/features/user/features/main/user_main_view.dart';
import 'package:taxi_app/features/user/features/profile/presentation/pages/change_email_user_view.dart';
import 'package:taxi_app/features/user/features/profile/presentation/pages/change_password_user_view.dart';
import 'package:taxi_app/features/user/features/profile/presentation/pages/user_update_profile_view.dart';

class RouterGenerationConfig {
  static GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        name: AppRoutes.splash,
        builder: (context, state) => const SplashView(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        name: AppRoutes.onboarding,
        builder: (context, state) => const OnbordingView(),
      ),
      GoRoute(
        path: AppRoutes.welcome,
        name: AppRoutes.welcome,
        builder: (context, state) => const WelcomeView(),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: AppRoutes.login,
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: AppRoutes.register,
        name: AppRoutes.register,
        builder: (context, state) => RegisterView(role: state.extra as String),
      ),
      GoRoute(
        path: AppRoutes.userMain,
        name: AppRoutes.userMain,
        builder: (context, state) => const UserMainView(),
      ),
      GoRoute(
        path: AppRoutes.userEditProfile,
        name: AppRoutes.userEditProfile,
        builder: (context, state) => const UserUpdateProfileView(),
      ),
      GoRoute(
        path: AppRoutes.userchangePasswordProfile,
        name: AppRoutes.userchangePasswordProfile,
        builder: (context, state) => const ChangePasswordUserView(),
      ),
      GoRoute(
        path: AppRoutes.userchangeEmailProfile,
        name: AppRoutes.userchangeEmailProfile,
        builder: (context, state) => const ChangeEmailUserView(),
      ),
      GoRoute(
        path: AppRoutes.language,
        name: AppRoutes.language,
        builder: (context, state) => const LanguageView(),
      ),
      GoRoute(
        path: AppRoutes.driverMain,
        name: AppRoutes.driverMain,
        builder: (context, state) => const DriverMainView(),
      ),
    ],
  );
}
