// lib/presentation/pages/splash/splash_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../../core/theme/app_theme.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _ctrl.forward();
    Future.delayed(const Duration(seconds: 2), _rediriger);
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  Future<void> _rediriger() async {
    if (!mounted) return;
    final s = ref.read(authProvider);
    if (s.user == null) context.go('/login');
    else if (!s.user!.onboardingFait) context.go('/onboarding');
    else if (s.user!.estArtisan) context.go('/artisan/dashboard');
    else context.go('/citoyen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryContainer,
      body: Center(
        child: FadeTransition(
          opacity: _fade,
          child: SlideTransition(
            position: _slide,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppTheme.inversePrimary,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 24, offset: const Offset(0, 8))],
                  ),
                  child: const Icon(Icons.handyman_rounded, size: 52, color: AppTheme.primaryContainer),
                ),
                const SizedBox(height: 24),
                const Text('Artisan Core', style: TextStyle(fontFamily: 'Hanken Grotesk', color: AppTheme.onPrimary, fontSize: 36, fontWeight: FontWeight.w800, letterSpacing: -0.5)),
                const SizedBox(height: 8),
                Text('Les artisans de chez nous, près de chez vous', style: TextStyle(color: AppTheme.onPrimary.withOpacity(0.7), fontSize: 14), textAlign: TextAlign.center),
                const SizedBox(height: 64),
                SizedBox(width: 28, height: 28, child: CircularProgressIndicator(color: AppTheme.inversePrimary, strokeWidth: 2.5, backgroundColor: Colors.white.withOpacity(0.2))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
