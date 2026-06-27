import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/pages/auth/login_page.dart';
import '../../presentation/pages/auth/reset_password_page.dart';
import '../../presentation/pages/auth/reset_password_confirm_page.dart';
import '../../presentation/pages/splash/splash_page.dart';
import '../../presentation/providers/auth_provider.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authNotifierProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    redirect: (context, state) {
      final isLoggedIn = authState.user != null;
      final isOnSplash = state.matchedLocation == '/splash';
      final isOnLogin = state.matchedLocation == '/login';
      final isOnReset = state.matchedLocation == '/reset-password';
      final isOnResetConfirm = state.matchedLocation == '/reset-password-confirm';

      if (isOnSplash) return null;
      if (!isLoggedIn && !isOnLogin && !isOnReset && !isOnResetConfirm) {
        return '/login';
      }
      if (isLoggedIn && isOnLogin) {
        final role = authState.user?.roleActif;
        if (role == 'artisan') return '/artisan/dashboard';
        return '/citoyen/accueil';
      }

      return null;
    },
    routes: [
      GoRoute(path: '/splash', builder: (context, state) => const SplashPage()),
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(
        path: '/reset-password',
        builder: (context, state) => const ResetPasswordPage(),
      ),
      GoRoute(
        path: '/reset-password-confirm',
        builder: (context, state) => const ResetPasswordConfirmPage(),
      ),
      GoRoute(
        path: '/citoyen/accueil',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Accueil Citoyen (à implémenter)')),
        ),
      ),
      GoRoute(
        path: '/artisan/dashboard',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Dashboard Artisan (à implémenter)')),
        ),
      ),
    ],
  );
});
