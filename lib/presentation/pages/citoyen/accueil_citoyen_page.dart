// lib/presentation/pages/citoyen/accueil_citoyen_page.dart
// Page d'accueil pour les citoyens : recherche, catégories, top artisans
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/design_system.dart';
import '../../widgets/skeletons.dart';
import '../../providers/commerce_provider.dart';
import 'detail_commerce_page.dart';

class AccueilCitoyenPage extends ConsumerStatefulWidget {
  const AccueilCitoyenPage({super.key});

  @override
  ConsumerState<AccueilCitoyenPage> createState() => _AccueilCitoyenPageState();
}

class _AccueilCitoyenPageState extends ConsumerState<AccueilCitoyenPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final commerceState = ref.watch(commerceProvider);
    final topCommerces = commerceState.commerces.take(4).toList();

    return Scaffold(
      backgroundColor: AppTheme.fondPrincipal,
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        color: AppTheme.accentPrimaire,
        backgroundColor: AppTheme.surfaceCard,
        onRefresh: () async {
          // Pull to refresh
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              _buildHeroSection(),
              const SizedBox(height: 40),
              _buildCategoriesSection(),
              const SizedBox(height: 40),
              _buildTopArtisansSection(topCommerces),
              const SizedBox(height: 40),
              _buildCTASection(),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.fondPrincipal,
      elevation: 0,
      title: Row(
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
          const SizedBox(width: 12),
          Text(
            'Artisan BF',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppTheme.textePrimaire,
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_outlined),
          color: AppTheme.texteSecondaire,
        ),
      ],
    );
  }

  Widget _buildHeroSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.bordureSubtile),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.accentSecondaire.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(99),
            ),
            child: Text(
              'Bienvenue à Ouagadougou',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppTheme.accentPrimaire,
                letterSpacing: 0.8,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Trouvez l'excellence artisanale à chaque coin de rue.",
            style: GoogleFonts.inter(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: AppTheme.textePrimaire,
              letterSpacing: -0.5,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Des professionnels de confiance pour tous vos besoins quotidiens.',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppTheme.texteSecondaire,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppTheme.textePrimaire,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Quel service cherchez-vous ?',
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppTheme.texteSecondaire,
                      size: 20,
                    ),
                    filled: true,
                    fillColor: AppTheme.surfaceCardHover,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onSubmitted: (value) {
                    if (value.trim().isNotEmpty) {
                      context.push('/citoyen/recherche');
                    }
                  },
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () => context.push('/citoyen/recherche'),
                child: Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: AppTheme.accentPrimaire,
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_rounded,
                    color: Color(0xFF0F0F0F),
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesSection() {
    const categories = [
      ('Mécaniciens', Icons.build_rounded),
      ('Couturiers', Icons.checkroom_rounded),
      ('Menuisiers', Icons.handyman_rounded),
      ('Électriciens', Icons.electrical_services_rounded),
      ('Coiffeurs', Icons.content_cut_rounded),
      ('Plombiers', Icons.plumbing_rounded),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Catégories',
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textePrimaire,
                    letterSpacing: -0.3,
                  ),
                ),
                Text(
                  'Parcourez nos métiers',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppTheme.texteSecondaire,
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () => context.push('/citoyen/recherche'),
              child: Row(
                children: [
                  Text(
                    'Voir tout',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.accentPrimaire,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_forward,
                    size: 16,
                    color: AppTheme.accentPrimaire,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.4,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final cat = categories[index];
            return GestureDetector(
              onTap: () => context.push('/citoyen/recherche'),
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.surfaceCard,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.bordureSubtile),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppTheme.accentSecondaire
                            .withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        cat.$2,
                        color: AppTheme.accentPrimaire,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      cat.$1,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textePrimaire,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTopArtisansSection(List<dynamic> commerces) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Les mieux notés',
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppTheme.textePrimaire,
            letterSpacing: -0.3,
          ),
        ),
        Text(
          "L'excellence près de chez vous",
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppTheme.texteSecondaire,
          ),
        ),
        const SizedBox(height: 16),
        if (commerces.isEmpty)
          ...List.generate(3, (_) => const SkeletonCard())
        else
          ...commerces.map((c) => GestureDetector(
                onTap: () => context.push('/citoyen/detail/${c.id}'),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceCard,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppTheme.bordureSubtile),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.horizontal(
                            left: Radius.circular(20)),
                        child: Container(
                          width: 100,
                          height: 100,
                          color: AppTheme.surfaceCardHover,
                          child: c.photos.isNotEmpty
                              ? Image.network(c.photos.first,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, _, _) =>
                                      const Icon(Icons.store,
                                          color: AppTheme.texteTertiaire))
                              : const Icon(Icons.store,
                                  color: AppTheme.texteTertiaire),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                c.nom,
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: AppTheme.textePrimaire,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                c.categorie.toUpperCase(),
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.accentPrimaire,
                                  letterSpacing: 0.8,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(Icons.star_rounded,
                                      size: 14,
                                      color: AppTheme.accentPrimaire),
                                  const SizedBox(width: 4),
                                  Text(
                                    c.noteMoyenne.toStringAsFixed(1),
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                      color: AppTheme.textePrimaire,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(Icons.location_on_outlined,
                                      size: 12,
                                      color: AppTheme.texteSecondaire),
                                  const SizedBox(width: 2),
                                  Expanded(
                                    child: Text(
                                      c.descriptionAdresse ??
                                          'À proximité',
                                      style: GoogleFonts.inter(
                                        fontSize: 11,
                                        color: AppTheme.texteSecondaire,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
      ],
    );
  }

  Widget _buildCTASection() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.bordureSubtile),
      ),
      child: Column(
        children: [
          Text(
            'Vous êtes un artisan ?',
            style: GoogleFonts.inter(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppTheme.textePrimaire,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Rejoignez la plus grande communauté de professionnels au Burkina Faso.',
            style: GoogleFonts.inter(
              color: AppTheme.texteSecondaire,
              fontSize: 14,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            label: "S'inscrire comme Artisan",
            onPressed: () => context.push('/login'),
            icon: Icons.handyman_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    final items = [
      (Icons.home_rounded, 'Accueil', true, ''),
      (Icons.search_rounded, 'Recherche', false, '/citoyen/recherche'),
      (Icons.map_rounded, 'Carte', false, '/citoyen/carte'),
      (Icons.person_rounded, 'Profil', false, '/login'),
    ];
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.fondPrincipal,
        border: Border(
          top: BorderSide(color: AppTheme.bordureSubtile, width: 0.5),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items.map((item) {
          final active = item.$3;
          return GestureDetector(
            onTap: () {
              if (item.$4.isNotEmpty) context.push(item.$4);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: active
                    ? AppTheme.accentPrimaire
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(99),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    item.$1,
                    size: 20,
                    color: active
                        ? const Color(0xFF0F0F0F)
                        : AppTheme.texteSecondaire,
                  ),
                  if (active) ...[
                    const SizedBox(width: 6),
                    Text(
                      item.$2,
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
        }).toList(),
      ),
    );
  }
}