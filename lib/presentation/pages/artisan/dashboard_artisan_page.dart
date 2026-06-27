// lib/presentation/pages/artisan/dashboard_artisan_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/commerce_provider.dart';
import '../../widgets/commerce_card.dart';
import '../../providers/auth_provider.dart';
import '../../../core/theme/app_theme.dart';

class DashboardArtisanPage extends ConsumerWidget {
  const DashboardArtisanPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mesCommercesAsync = ref.watch(mesCommercesProvider);
    final user = ref.watch(authProvider).user;

    return Scaffold(
      backgroundColor: AppTheme.neutralSand,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              color: AppTheme.surfaceContainerLow,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryContainer,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Icon(Icons.person_rounded, color: AppTheme.onPrimaryContainer, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user != null ? 'Bonjour, ${user.nom.split(' ').first}' : 'Bonjour',
                          style: const TextStyle(fontFamily: 'Hanken Grotesk', fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.primary),
                        ),
                        const Text('Gérez votre activité', style: TextStyle(fontSize: 13, color: AppTheme.onSurfaceVariant)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout_rounded, color: AppTheme.onSurfaceVariant),
                    onPressed: () {
                      ref.read(authProvider.notifier).logout();
                      context.go('/login');
                    },
                  ),
                ],
              ),
            ),

            Expanded(
              child: mesCommercesAsync.when(
                loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.primary)),
                error: (err, _) => Center(child: Text('Erreur : $err', style: const TextStyle(color: AppTheme.error))),
                data: (commerces) {
                  if (commerces.isEmpty) return _buildEmptyState(context);
                  return ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      // Stats row
                      Row(
                        children: [
                          _StatCard(label: 'Commerces', value: '${commerces.length}', icon: Icons.storefront_rounded),
                          const SizedBox(width: 12),
                          _StatCard(
                            label: 'Publiés',
                            value: '${commerces.where((c) => c.estPublie).length}',
                            icon: Icons.visibility_rounded,
                            color: AppTheme.primaryContainer,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Mes Commerces', style: TextStyle(fontFamily: 'Hanken Grotesk', fontSize: 18, fontWeight: FontWeight.w600, color: AppTheme.onSurface)),
                          GestureDetector(
                            onTap: () => context.push('/artisan/creer'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(999)),
                              child: const Row(
                                children: [
                                  Icon(Icons.add_rounded, color: AppTheme.onPrimary, size: 16),
                                  SizedBox(width: 4),
                                  Text('Ajouter', style: TextStyle(color: AppTheme.onPrimary, fontWeight: FontWeight.w600, fontSize: 13)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ...commerces.map((c) => Column(
                        children: [
                          CommerceCard(commerce: c),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12, left: 4, right: 4),
                            child: Row(
                              children: [
                                _ActionChip(
                                  icon: Icons.edit_rounded,
                                  label: 'Modifier',
                                  onTap: () => context.push('/artisan/editer/${c.id}'),
                                ),
                                const SizedBox(width: 8),
                                _ActionChip(
                                  icon: c.estPublie ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                                  label: c.estPublie ? 'Publié' : 'Brouillon',
                                  color: c.estPublie ? AppTheme.primaryContainer : AppTheme.secondary,
                                  textColor: c.estPublie ? AppTheme.onPrimaryContainer : AppTheme.onSecondary,
                                  onTap: () => context.push('/artisan/publication/${c.id}', extra: c.estPublie),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _BottomNav(currentIndex: 0, onTap: (i) {
        if (i == 1) context.push('/artisan/creer');
      }),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(color: AppTheme.surfaceContainerHigh, borderRadius: BorderRadius.circular(24)),
              child: const Icon(Icons.storefront_rounded, size: 44, color: AppTheme.primary),
            ),
            const SizedBox(height: 20),
            const Text('Aucun commerce encore', style: TextStyle(fontFamily: 'Hanken Grotesk', fontSize: 20, fontWeight: FontWeight.w700, color: AppTheme.onSurface)),
            const SizedBox(height: 8),
            const Text('Créez votre première fiche pour être visible par les clients.', textAlign: TextAlign.center, style: TextStyle(color: AppTheme.onSurfaceVariant, height: 1.5)),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: () => context.push('/artisan/creer'),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Créer mon commerce'),
              style: ElevatedButton.styleFrom(minimumSize: const Size(200, 52)),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;
  const _StatCard({required this.label, required this.value, required this.icon, this.color = AppTheme.surfaceContainerHigh});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.outlineVariant.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(label, style: const TextStyle(fontSize: 13, color: AppTheme.onSurfaceVariant, fontWeight: FontWeight.w500)),
                Icon(icon, size: 20, color: AppTheme.primary),
              ],
            ),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontFamily: 'Hanken Grotesk', fontSize: 24, fontWeight: FontWeight.w700, color: AppTheme.primary)),
          ],
        ),
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;
  final Color textColor;
  const _ActionChip({required this.icon, required this.label, required this.onTap, this.color = AppTheme.surfaceContainerHigh, this.textColor = AppTheme.onSurface});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(8), border: Border.all(color: color.withOpacity(0.3))),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: textColor == AppTheme.onSecondary ? AppTheme.secondary : AppTheme.primary),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: textColor == AppTheme.onSecondary ? AppTheme.secondary : AppTheme.primary)),
          ],
        ),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;
  const _BottomNav({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.dashboard_rounded, 'Dashboard'),
      (Icons.add_circle_outline_rounded, 'Ajouter'),
      (Icons.inventory_2_outlined, 'Mes Offres'),
      (Icons.visibility_outlined, 'Visibilité'),
    ];
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border(top: BorderSide(color: AppTheme.outlineVariant.withOpacity(0.5))),
        boxShadow: [BoxShadow(color: AppTheme.primary.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, -4))],
      ),
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (i) {
          final selected = i == currentIndex;
          return GestureDetector(
            onTap: () => onTap(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: selected ? AppTheme.primaryContainer.withOpacity(0.2) : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(items[i].$1, color: selected ? AppTheme.primary : AppTheme.onSurfaceVariant, size: 22),
                  const SizedBox(height: 2),
                  Text(items[i].$2, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: selected ? AppTheme.primary : AppTheme.onSurfaceVariant)),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
