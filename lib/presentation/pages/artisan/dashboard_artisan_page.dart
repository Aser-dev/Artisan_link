// lib/presentation/pages/artisan/dashboard_artisan_page.dart
// Dashboard principal de l'artisan : statistiques, liste des commerces, actions
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import '../../providers/commerce_provider.dart';
import '../../widgets/commerce_card.dart';
import '../../providers/auth_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/design_system.dart';
import '../../widgets/skeletons.dart';

class DashboardArtisanPage extends ConsumerWidget {
  const DashboardArtisanPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mesCommercesAsync = ref.watch(mesCommercesProvider);
    final user = ref.watch(authProvider).user;

    return Scaffold(
      backgroundColor: AppTheme.fondPrincipal,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              color: AppTheme.fondPrincipal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppTheme.accentSecondaire,
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: const Icon(Icons.person_rounded,
                        color: AppTheme.accentPrimaire, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user != null
                              ? 'Bonjour, ${user.nom.split(' ').first}'
                              : 'Bonjour',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textePrimaire,
                          ),
                        ),
                        Text(
                          'Gérez votre activité',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: AppTheme.texteSecondaire,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout_rounded,
                        color: AppTheme.texteSecondaire),
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      ref.read(authProvider.notifier).logout();
                      context.go('/login');
                    },
                  ),
                ],
              ),
            ),

            Expanded(
              child: mesCommercesAsync.when(
                loading: () => ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: 2,
                  itemBuilder: (_, _) => const SkeletonCard(),
                ),
                error: (err, _) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            color: AppTheme.erreur.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(Icons.error_outline_rounded,
                              size: 36, color: AppTheme.erreur),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Impossible de charger vos données',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textePrimaire,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '$err',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: AppTheme.texteSecondaire,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        AppActionChip(
                          icon: Icons.refresh_rounded,
                          label: 'Réessayer',
                          onTap: () =>
                              ref.invalidate(mesCommercesProvider),
                          color: AppTheme.accentPrimaire,
                          textColor: AppTheme.accentPrimaire,
                        ),
                      ],
                    ),
                  ),
                ),
                data: (commerces) {
                  if (commerces.isEmpty) {
                    return _buildEmptyState(context);
                  }
                  return RefreshIndicator(
                    color: AppTheme.accentPrimaire,
                    backgroundColor: AppTheme.surfaceCard,
                    onRefresh: () async {
                      ref.invalidate(mesCommercesProvider);
                    },
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        // Stats row
                        Row(
                          children: [
                            StatCard(
                              label: 'Commerces',
                              value: '${commerces.length}',
                              icon: Icons.storefront_rounded,
                            ),
                            const SizedBox(width: 12),
                            StatCard(
                              label: 'Publiés',
                              value:
                                  '${commerces.where((c) => c.estPublie).length}',
                              icon: Icons.visibility_rounded,
                              color: AppTheme.accentPrimaire,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Mes Commerces',
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textePrimaire,
                              ),
                            ),
                            GestureDetector(
                              onTap: () =>
                                  context.push('/artisan/creer'),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  color: AppTheme.accentPrimaire,
                                  borderRadius: BorderRadius.circular(99),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.add_rounded,
                                        color: Color(0xFF0F0F0F),
                                        size: 16),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Ajouter',
                                      style: GoogleFonts.inter(
                                        color: const Color(0xFF0F0F0F),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ...commerces.map(
                          (c) => Column(
                            children: [
                              CommerceCard(commerce: c),
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 12, left: 4, right: 4),
                                child: Row(
                                  children: [
                                    AppActionChip(
                                      icon: Icons.edit_rounded,
                                      label: 'Modifier',
                                      onTap: () => context.push(
                                          '/artisan/editer/${c.id}'),
                                    ),
                                    const SizedBox(width: 8),
                                    AppActionChip(
                                      icon: c.estPublie
                                          ? Icons.visibility_rounded
                                          : Icons.visibility_off_rounded,
                                      label: c.estPublie
                                          ? 'Publié'
                                          : 'Brouillon',
                                      color: c.estPublie
                                          ? AppTheme.accentPrimaire
                                          : AppTheme.texteTertiaire,
                                      textColor: c.estPublie
                                          ? AppTheme.accentPrimaire
                                          : AppTheme.texteTertiaire,
                                      onTap: () => context.push(
                                          '/artisan/publication/${c.id}',
                                          extra: c.estPublie),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _BottomNav(
        currentIndex: 0,
        onTap: (i) {
          if (i == 1) context.push('/artisan/creer');
        },
      ),
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
              decoration: BoxDecoration(
                color: AppTheme.surfaceCard,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppTheme.bordureSubtile),
              ),
              child: const Icon(Icons.storefront_rounded,
                  size: 44, color: AppTheme.accentPrimaire),
            ),
            const SizedBox(height: 20),
            Text(
              'Aucun commerce encore',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppTheme.textePrimaire,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Créez votre première fiche pour être visible par les clients.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: AppTheme.texteSecondaire,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),
            PrimaryButton(
              label: 'Créer mon commerce',
              onPressed: () => context.push('/artisan/creer'),
              icon: Icons.add_rounded,
            ),
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
        color: AppTheme.fondPrincipal,
        border: Border(
            top:
                BorderSide(color: AppTheme.bordureSubtile, width: 0.5)),
      ),
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (i) {
          final selected = i == currentIndex;
          return GestureDetector(
            onTap: () => onTap(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: selected
                    ? AppTheme.accentPrimaire
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(99),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    items[i].$1,
                    color: selected
                        ? const Color(0xFF0F0F0F)
                        : AppTheme.texteSecondaire,
                    size: 20,
                  ),
                  if (selected) ...[
                    const SizedBox(width: 6),
                    Text(
                      items[i].$2,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF0F0F0F),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}