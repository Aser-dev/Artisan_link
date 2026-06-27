// lib/core/routes/app_router.dart
import 'package:go_router/go_router.dart';
import '../../presentation/pages/splash/splash_page.dart';
import '../../presentation/pages/auth/login_page.dart';
import '../../presentation/pages/auth/reset_password_page.dart';
import '../../presentation/pages/onboarding/onboarding_page.dart';
import '../../presentation/pages/citoyen/accueil_citoyen_page.dart';
import '../../presentation/pages/citoyen/detail_commerce_page.dart';
import '../../presentation/pages/citoyen/donner_avis_page.dart';
import '../../presentation/pages/artisan/dashboard_artisan_page.dart';
import '../../presentation/pages/artisan/creer_commerce_page.dart';
import '../../presentation/pages/artisan/gerer_publication_page.dart';
import '../../presentation/pages/artisan/editer_commerce_page.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashPage()),
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(path: '/reset-password', builder: (context, state) => const ResetPasswordPage()),
    GoRoute(path: '/onboarding', builder: (context, state) => const OnboardingPage()),
    GoRoute(path: '/citoyen', builder: (context, state) => const AccueilCitoyenPage()),
    GoRoute(
      path: '/detail/:id',
      builder: (context, state) => DetailCommercePage(commerceId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/donner-avis/:commerceId',
      builder: (context, state) => DonnerAvisPage(commerceId: state.pathParameters['commerceId']!),
    ),
    GoRoute(path: '/artisan/dashboard', builder: (context, state) => const DashboardArtisanPage()),
    GoRoute(path: '/artisan/creer', builder: (context, state) => const CreerCommercePage()),
    GoRoute(
      path: '/artisan/editer/:id',
      builder: (context, state) => EditerCommercePage(commerceId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/artisan/publication/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        final estPublie = state.extra as bool? ?? false;
        return GererPublicationPage(commerceId: id, estPublieActuel: estPublie);
      },
    ),
  ],
);
