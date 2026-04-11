import 'package:go_router/go_router.dart';
import 'package:taxi_app/core/routing/app_routes.dart';
import 'package:taxi_app/features/auth/presentation/pages/login_view.dart';
import 'package:taxi_app/features/auth/presentation/pages/register_view.dart';
import 'package:taxi_app/features/intro/onbording/presentation/views/onbording_view.dart';
import 'package:taxi_app/features/intro/splash/presentation/views/splash_view.dart';
import 'package:taxi_app/features/intro/welcome/presentation/views/welcome_view.dart';
import 'package:taxi_app/features/user/features/home/presentation/pages/user_home_view.dart';

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
        builder: (context, state) => const UserHomeView(),
      ),
    ],
  );
}
