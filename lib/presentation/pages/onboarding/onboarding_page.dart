// lib/presentation/pages/onboarding/onboarding_page.dart
// Choix du rôle une seule fois après l'inscription
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/auth_provider.dart';
import '../../../core/constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/design_system.dart';

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
    HapticFeedback.lightImpact();
    context.go(_roleChoisi == AppConstants.roleArtisan
        ? '/artisan/dashboard'
        : '/citoyen');
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final prenom = authState.user?.nom.split(' ').first ?? '';

    return Scaffold(
      backgroundColor: AppTheme.fondPrincipal,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              // Logo
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppTheme.accentSecondaire,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.handyman_rounded,
                      color: AppTheme.accentPrimaire,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Artisan BF',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                      color: AppTheme.textePrimaire,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Text(
                'Bienvenue${prenom.isNotEmpty ? ', $prenom' : ''}',
                style: GoogleFonts.inter(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textePrimaire,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Comment allez-vous utiliser Artisan BF ?',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  color: AppTheme.texteSecondaire,
                ),
              ),
              const SizedBox(height: 32),

              // Choix Citoyen
              _roleCard(
                role: AppConstants.roleCitoyen,
                titre: 'Je cherche un artisan',
                description:
                    'Trouvez des mécaniciens, couturiers, coiffeurs et bien plus près de chez vous.',
                icon: Icons.search_rounded,
              ),
              const SizedBox(height: 14),

              // Choix Artisan
              _roleCard(
                role: AppConstants.roleArtisan,
                titre: 'Je suis artisan',
                description:
                    'Publiez vos services et soyez visible par des milliers de clients dans votre quartier.',
                icon: Icons.handyman_rounded,
              ),

              const Spacer(),
              Text(
                'Vous pouvez changer de mode depuis votre profil.',
                style: GoogleFonts.inter(
                  color: AppTheme.texteTertiaire,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 14),
              PrimaryButton(
                label: 'Continuer',
                isLoading: authState.isLoading,
                onPressed: _roleChoisi != null ? _confirmer : null,
                icon: Icons.arrow_forward_rounded,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _roleCard({
    required String role,
    required String titre,
    required String description,
    required IconData icon,
  }) {
    final selected = _roleChoisi == role;
    return GestureDetector(
      onTap: () => setState(() => _roleChoisi = role),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.surfaceCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppTheme.accentPrimaire : AppTheme.bordureSubtile,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: selected
                    ? AppTheme.accentSecondaire
                    : AppTheme.surfaceCardHover,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: selected ? AppTheme.accentPrimaire : AppTheme.texteSecondaire,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titre,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: selected
                          ? AppTheme.accentPrimaire
                          : AppTheme.textePrimaire,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppTheme.texteSecondaire,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            AnimatedOpacity(
              opacity: selected ? 1 : 0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                Icons.check_circle_rounded,
                color: AppTheme.accentPrimaire,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}