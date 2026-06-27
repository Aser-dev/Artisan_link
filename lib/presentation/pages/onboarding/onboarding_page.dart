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
      _roleChoisi == AppConstants.roleArtisan ? '/artisan/dashboard' : '/citoyen',
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.user;
    final prenom = user?.nom.split(' ').first ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              // Header
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFF8CD82C),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.handyman_rounded, size: 22, color: Color(0xFF1E1E1E)),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'ArtisanBF',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E4A0B),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Text(
                'Bienvenue${ prenom.isNotEmpty ? ', $prenom' : ''} 👋',
                style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xFF1E1E1E)),
              ),
              const SizedBox(height: 8),
              const Text(
                'Comment allez-vous utiliser ArtisanBF ?',
                style: TextStyle(fontSize: 16, color: Color(0xFF6C757D)),
              ),
              const SizedBox(height: 36),

              _buildRoleCard(
                role: AppConstants.roleCitoyen,
                titre: 'Je cherche un artisan',
                description: 'Trouvez des mécaniciens, couturiers, coiffeurs et bien plus près de chez vous.',
                icon: Icons.search_rounded,
                couleur: const Color(0xFF1565C0),
                fondCouleur: const Color(0xFFE3F2FD),
              ),
              const SizedBox(height: 16),
              _buildRoleCard(
                role: AppConstants.roleArtisan,
                titre: 'Je suis artisan',
                description: 'Publiez vos services et soyez visible par des milliers de clients dans votre quartier.',
                icon: Icons.handyman_rounded,
                couleur: const Color(0xFF2E7D32),
                fondCouleur: const Color(0xFFE8F5E9),
              ),

              const Spacer(),
              Center(
                child: Text(
                  'Vous pouvez changer de mode depuis votre profil.',
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: (_roleChoisi == null || authState.isLoading) ? null : _confirmer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _roleChoisi != null ? const Color(0xFF8CD82C) : const Color(0xFFE9ECEF),
                    foregroundColor: const Color(0xFF1E1E1E),
                    elevation: _roleChoisi != null ? 0 : 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: authState.isLoading
                      ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Color(0xFF1E1E1E), strokeWidth: 2))
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Continuer', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward, size: 18),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 24),
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
              ? [BoxShadow(color: couleur.withOpacity(0.12), blurRadius: 16, offset: const Offset(0, 4))]
              : [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: estSelectionne ? couleur : fondCouleur,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: estSelectionne ? Colors.white : couleur, size: 30),
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
                  const SizedBox(height: 6),
                  Text(description, style: const TextStyle(fontSize: 13, color: Colors.grey, height: 1.4)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            AnimatedOpacity(
              opacity: estSelectionne ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Icon(Icons.check_circle_rounded, color: couleur, size: 26),
            ),
          ],
        ),
      ),
    );
  }
}
