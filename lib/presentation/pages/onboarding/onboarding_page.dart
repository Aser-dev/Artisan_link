// lib/presentation/pages/onboarding/onboarding_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../../core/constants.dart';

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
    context.go(
      _roleChoisi == AppConstants.roleArtisan
          ? '/artisan/dashboard'
          : '/citoyen',
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Text(
                'Bonjour ${user?.nom.split(' ').first ?? ''} 👋',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Comment allez-vous utiliser ArtisanBF ?',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 40),

              _buildRoleCard(
                role: AppConstants.roleCitoyen,
                titre: 'Je cherche un artisan',
                description:
                    'Trouvez des mécaniciens, couturiers, coiffeurs et bien plus près de chez vous.',
                icon: Icons.search_rounded,
                couleur: const Color(0xFF1565C0),
                fondCouleur: const Color(0xFFE3F2FD),
              ),
              const SizedBox(height: 16),

              _buildRoleCard(
                role: AppConstants.roleArtisan,
                titre: 'Je suis artisan',
                description:
                    'Publiez vos services et soyez visible par des milliers de clients dans votre quartier.',
                icon: Icons.handyman_rounded,
                couleur: const Color(0xFF2E7D32),
                fondCouleur: const Color(0xFFE8F5E9),
              ),

              const Spacer(),
              const Text(
                'Vous pouvez changer de mode à tout moment depuis votre profil.',
                style: TextStyle(color: Colors.grey, fontSize: 12),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: (_roleChoisi == null || authState.isLoading)
                      ? null
                      : _confirmer,
                  child: authState.isLoading
                      ? const CircularProgressIndicator(
                          color: Color(0xFF1E1E1E),
                          strokeWidth: 2,
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Continuer',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward, size: 18),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required String role,
    required String titre,
    required String description,
    required IconData icon,
    required Color couleur,
    required Color fondCouleur,
  }) {
    final estSelectionne = _roleChoisi == role;

    return GestureDetector(
      onTap: () => setState(() => _roleChoisi = role),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: estSelectionne ? couleur : const Color(0xFFE9ECEF),
            width: estSelectionne ? 2 : 1,
          ),
          boxShadow: estSelectionne
              ? [BoxShadow(color: couleur.withOpacity(0.15), blurRadius: 12)]
              : [],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: estSelectionne ? couleur : fondCouleur,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: estSelectionne ? Colors.white : couleur,
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
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: estSelectionne ? couleur : const Color(0xFF1E1E1E),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            if (estSelectionne)
              Icon(Icons.check_circle_rounded, color: couleur, size: 24),
          ],
        ),
      ),
    );
  }
}
