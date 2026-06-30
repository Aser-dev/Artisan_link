import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/pages/auth/login_page.dart';
import '../../presentation/pages/auth/reset_password_page.dart';
import '../../presentation/pages/auth/reset_password_confirm_page.dart';
import '../../presentation/pages/splash/splash_page.dart';
import '../../presentation/providers/auth_provider.dart';

import '../../presentation/pages/onboarding/onboarding_page.dart';
import '../../presentation/pages/citoyen/accueil_citoyen_page.dart';
import '../../presentation/pages/citoyen/detail_commerce_page.dart';
import '../../presentation/pages/citoyen/liste_recherche_page.dart';
import '../../presentation/pages/citoyen/carte_page.dart';
import '../../presentation/pages/citoyen/donner_avis_page.dart';

import '../../presentation/pages/artisan/dashboard_artisan_page.dart';
import '../../presentation/pages/artisan/creer_commerce_page.dart';
import '../../presentation/pages/artisan/editer_commerce_page.dart';
import '../../presentation/pages/artisan/gerer_publication_page.dart';

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
      GoRoute(path: '/reset-password', builder: (context, state) => const ResetPasswordPage()),
      GoRoute(
        path: '/reset-password-confirm',
        builder: (context, state) => const ResetPasswordConfirmPage(),
      ),
      GoRoute(path: '/onboarding', builder: (context, state) => const OnboardingPage()),

      // Citoyen
      GoRoute(
        path: '/citoyen/accueil',
        builder: (context, state) => const AccueilCitoyenPage(),
      ),
      GoRoute(
        path: '/citoyen',
        builder: (context, state) => const AccueilCitoyenPage(),
      ),
      GoRoute(
        path: '/citoyen/recherche',
        builder: (context, state) => const ListeRecherchePage(),
      ),
      GoRoute(
        path: '/citoyen/carte',
        builder: (context, state) => const CartePage(),
      ),
      GoRoute(
        path: '/citoyen/detail/:id',
        builder: (context, state) =>
            DetailCommercePage(commerceId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/donner-avis/:commerceId',
        builder: (context, state) =>
            DonnerAvisPage(commerceId: state.pathParameters['commerceId']!),
      ),

      // Artisan
      GoRoute(
        path: '/artisan/dashboard',
        builder: (context, state) => const DashboardArtisanPage(),
      ),
      GoRoute(
        path: '/artisan/creer',
        builder: (context, state) => const CreerCommercePage(),
      ),
      GoRoute(
        path: '/artisan/editer/:id',
        builder: (context, state) =>
            EditerCommercePage(commerceId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/artisan/publication/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          final estPublie = (state.extra is bool) ? state.extra as bool : false;
          return GererPublicationPage(
            commerceId: id,
            estPublieActuel: estPublie,
          );
        },
      ),
    ],
  );
});

