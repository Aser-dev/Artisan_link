// lib/presentation/pages/onboarding/onboarding_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../../core/constants.dart';
import '../../../core/theme/app_theme.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  String? _roleChoisi;

  Future<void> _confirmer() async {
    if (_roleChoisi == null) return;
    await ref.read(authProvider.notifier).setRole(role: _roleChoisi!);
    if (!mounted) return;
    context.go(_roleChoisi == AppConstants.roleArtisan ? '/artisan/dashboard' : '/citoyen');
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final prenom = authState.user?.nom.split(' ').first ?? '';

    return Scaffold(
      backgroundColor: AppTheme.neutralSand,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              Row(children: [
                Container(width: 40, height: 40, decoration: BoxDecoration(color: AppTheme.primaryContainer, borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.handyman_rounded, color: AppTheme.onPrimaryContainer, size: 22)),
                const SizedBox(width: 10),
                const Text('Artisan Core', style: TextStyle(fontFamily: 'Hanken Grotesk', fontWeight: FontWeight.w700, fontSize: 17, color: AppTheme.primary)),
              ]),
              const SizedBox(height: 36),
              Text('Bienvenue${prenom.isNotEmpty ? ', $prenom' : ''} 👋',
                style: const TextStyle(fontFamily: 'Hanken Grotesk', fontSize: 26, fontWeight: FontWeight.w700, color: AppTheme.onSurface)),
              const SizedBox(height: 6),
              const Text('Comment allez-vous utiliser Artisan Core ?', style: TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 15)),
              const SizedBox(height: 32),

              _roleCard(role: AppConstants.roleCitoyen, titre: 'Je cherche un artisan',
                description: 'Trouvez des mécaniciens, couturiers, coiffeurs et bien plus près de chez vous.',
                icon: Icons.search_rounded, couleur: AppTheme.primaryContainer, bg: AppTheme.surfaceContainerLow),
              const SizedBox(height: 14),
              _roleCard(role: AppConstants.roleArtisan, titre: 'Je suis artisan',
                description: 'Publiez vos services et soyez visible par des milliers de clients dans votre quartier.',
                icon: Icons.handyman_rounded, couleur: AppTheme.secondary, bg: Color(0xFFFFF3F0)),

              const Spacer(),
              Text('Vous pouvez changer de mode depuis votre profil.', style: TextStyle(color: AppTheme.onSurfaceVariant.withValues(alpha: 0.7), fontSize: 12), textAlign: TextAlign.center),
              const SizedBox(height: 14),
              SizedBox(width: double.infinity, height: 54,
                child: ElevatedButton(
                  onPressed: (_roleChoisi == null || authState.isLoading) ? null : _confirmer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _roleChoisi != null ? AppTheme.primary : AppTheme.surfaceContainerHigh,
                    foregroundColor: _roleChoisi != null ? AppTheme.onPrimary : AppTheme.onSurfaceVariant,
                  ),
                  child: authState.isLoading
                      ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(color: AppTheme.onPrimary, strokeWidth: 2))
                      : const Text('Continuer', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                )),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _roleCard({required String role, required String titre, required String description, required IconData icon, required Color couleur, required Color bg}) {
    final selected = _roleChoisi == role;
    return GestureDetector(
      onTap: () => setState(() => _roleChoisi = role),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: selected ? couleur : AppTheme.outlineVariant.withValues(alpha: 0.4), width: selected ? 2 : 1),
          boxShadow: selected ? [BoxShadow(color: couleur.withValues(alpha: 0.12), blurRadius: 14, offset: const Offset(0, 4))] : [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
        ),
        child: Row(children: [
          Container(width: 56, height: 56, decoration: BoxDecoration(color: selected ? couleur : bg, borderRadius: BorderRadius.circular(14)),
            child: Icon(icon, color: selected ? Colors.white : couleur, size: 28)),
          const SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(titre, style: TextStyle(fontFamily: 'Hanken Grotesk', fontSize: 15, fontWeight: FontWeight.w700, color: selected ? couleur : AppTheme.onSurface)),
            const SizedBox(height: 4),
            Text(description, style: const TextStyle(fontSize: 13, color: AppTheme.onSurfaceVariant, height: 1.4)),
          ])),
          const SizedBox(width: 8),
          AnimatedOpacity(opacity: selected ? 1 : 0, duration: const Duration(milliseconds: 200),
            child: Icon(Icons.check_circle_rounded, color: couleur, size: 24)),
        ]),
      ),
    );
  }
}
