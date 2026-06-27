// lib/presentation/pages/splash/splash_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../../core/constants.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), _rediriger);
  }

  Future<void> _rediriger() async {
    if (!mounted) return;
    final authState = ref.read(authProvider);
    if (authState.user == null) {
      context.go('/login');
    } else if (!authState.user!.onboardingFait) {
      context.go('/onboarding');
    } else if (authState.user!.estArtisan) {
      context.go('/artisan/dashboard');
    } else {
      context.go('/citoyen');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E4A0B),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: const Color(0xFF8CD82C),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.handyman_rounded,
                size: 48,
                color: Color(0xFF1E1E1E),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'ArtisanBF',
              style: TextStyle(
                color: Colors.white,
                fontSize: 34,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Les artisans de chez nous, près de chez vous',
              style: TextStyle(color: Colors.white70, fontSize: 13),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 60),
            const CircularProgressIndicator(
              color: Color(0xFF8CD82C),
              strokeWidth: 2,
            ),
          ],
        ),
      ),
    );
  }
}
