// lib/presentation/pages/citoyen/accueil_citoyen_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/category_model.dart';
import '../../../core/models/artisan_model.dart';




class AccueilCitoyenPage extends ConsumerStatefulWidget {
  const AccueilCitoyenPage({super.key});

  @override
  ConsumerState<AccueilCitoyenPage> createState() =>
      _AccueilCitoyenPageState();
}

class _AccueilCitoyenPageState extends ConsumerState<AccueilCitoyenPage> {
  final TextEditingController _searchController = TextEditingController();


  // ─── Data ────────────────────────────────────────────────
  static const List<CategoryModel> _categories = [
    CategoryModel(
      label: 'Mécaniciens',
      icon: Icons.settings,
      imageUrl: 'https://...',
      gradientColor: AppTheme.primary,
    ),
    // ... autres catégories
  ];

  static const List<ArtisanModel> _topArtisans = [
    ArtisanModel(
      name: 'Atelier Sawadogo',
      category: 'MAÎTRE FERRONNIER',
      rating: 4.9,
      distance: 'Pissy, à 1.2 km',
      summary: 'Travail de précision exceptionnel.',
      actionLabel: 'Contacter maintenant',
      imageUrl: 'https://...',
      buttonColor: AppTheme.primary,
    ),
    // ... autres artisans
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ─── Build ────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8.0),
_HeroSection(searchController: _searchController),
            const SizedBox(height: 40.0),
            _buildCategoriesSection(),
            const SizedBox(height: 40.0),
            _buildTopArtisansSection(),
            const SizedBox(height: 40.0),
            const _CTASection(),
            const SizedBox(height: 80.0), // pour la bottom nav
          ],
        ),
      ),
      bottomNavigationBar: const _BottomNavBar(),
    );
  }

  // ─── AppBar ──────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.background,
      elevation: 0,
      title: Row(
        children: [
          ClipOval(
            child: Image.network(
              'https://...',
              width: 40,
              height: 40,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const Icon(Icons.person),
            ),
          ),
          const SizedBox(width: 12.0),
          const Text(
            'Artisan Core',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: AppTheme.primary,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_outlined),
          color: AppTheme.primary,
        ),
      ],
    );
  }

  // ─── Categories Section ──────────────────────────────────

  Widget _buildCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Catégories Vedettes',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primary,
                  ),
                ),
                Text(
                  'Parcourez nos métiers les plus sollicités',
                  style: TextStyle(color: AppTheme.onSurfaceVariant),
                ),
              ],
            ),
            TextButton(
              onPressed: () {},
              child: const Row(
                children: [
                  Text(
                    'Voir tout',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primary,
                    ),
                  ),
                  SizedBox(width: 4.0),
                  Icon(Icons.arrow_forward, size: 16.0, color: AppTheme.primary),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16.0),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16.0,
            crossAxisSpacing: 16.0,
            childAspectRatio: 1.2,
          ),
          itemCount: _categories.length,
          itemBuilder: (context, index) {
            final cat = _categories[index];
            return _CategoryCard(category: cat);
          },
        ),
      ],
    );
  }

  // ─── Top Artisans Section ───────────────────────────────

  Widget _buildTopArtisansSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Les mieux notés à proximité',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w600,
            color: AppTheme.primary,
          ),
        ),
        const Text(
          "L'excellence confirmée par la communauté",
          style: TextStyle(color: AppTheme.onSurfaceVariant),
        ),
        const SizedBox(height: 16.0),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _topArtisans.length,
          itemBuilder: (context, index) {
            final artisan = _topArtisans[index];
            return _ArtisanCard(artisan: artisan);
          },
        ),
      ],
    );
  }
}

// ─── Hero Section ──────────────────────────────────────────

class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.searchController});

  final TextEditingController searchController;


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: AppTheme.primaryContainer,
        borderRadius: BorderRadius.circular(24.0),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 12.0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
            decoration: BoxDecoration(
              color: AppTheme.savannahGold.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: const Text(
              'Bienvenue à Ouagadougou',
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w600,
                color: AppTheme.savannahGold,
              ),
            ),
          ),
          const SizedBox(height: 12.0),
          const Text(
            "Trouvez l'excellence artisanale à chaque coin de rue.",
            style: TextStyle(
              fontSize: 26.0,
              fontWeight: FontWeight.bold,
              color: AppTheme.onPrimaryContainer,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8.0),
          const Text(
            'Des professionnels de confiance pour tous vos besoins quotidiens, du dépannage à la création sur mesure.',
            style: TextStyle(
              fontSize: 16.0,
              color: AppTheme.onPrimaryContainer,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20.0),
          Row(
            children: [
              Expanded(
                child: TextField(
controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Quel service cherchez-vous ?',
                    prefixIcon: const Icon(Icons.search, color: AppTheme.outline),
                    filled: true,
                    fillColor: AppTheme.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 14.0),
                  ),
                ),
              ),
              const SizedBox(width: 12.0),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: AppTheme.onPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: const Text(
                  'Explorer',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Category Card ─────────────────────────────────────────

class _CategoryCard extends StatelessWidget {
  final CategoryModel category;
  const _CategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(16.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          image: DecorationImage(
            image: NetworkImage(category.imageUrl),
            fit: BoxFit.cover,
            onError: (_, _) => const AssetImage('assets/images/placeholder.png'),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, category.gradientColor.withValues(alpha: 0.8)],
              stops: const [0.5, 1.0],
            ),
          ),
          padding: const EdgeInsets.all(12.0),
          alignment: Alignment.bottomLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(category.icon, color: Colors.white, size: 24.0),
              const SizedBox(height: 4.0),
              Text(
                category.label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Artisan Card ─────────────────────────────────────────

class _ArtisanCard extends StatelessWidget {
  final ArtisanModel artisan;
  const _ArtisanCard({required this.artisan});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: AppTheme.outlineVariant),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 12.0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
                child: Image.network(
                  artisan.imageUrl,
                  height: 120.0,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    height: 120.0,
                    color: AppTheme.surfaceVariant,
                    child: const Icon(Icons.image, color: Colors.grey),
                  ),
                ),
              ),
              Positioned(
                top: 12.0,
                right: 12.0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, color: AppTheme.savannahGold, size: 14.0),
                      const SizedBox(width: 4.0),
                      Text(
                        artisan.rating.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  artisan.category,
                  style: const TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.terracottaClay,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  artisan.name,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 14.0, color: AppTheme.outline),
                    const SizedBox(width: 4.0),
                    Text(
                      artisan.distance,
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: AppTheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(8.0),
                    border: const Border(left: BorderSide(color: AppTheme.primary, width: 4.0)),
                  ),
                  child: Text(
                    '"${artisan.summary}" — AI Summary',
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontStyle: FontStyle.italic,
                      color: AppTheme.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(height: 12.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: artisan.buttonColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: Text(
                      artisan.actionLabel,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── CTA Section ───────────────────────────────────────────

class _CTASection extends StatelessWidget {
  const _CTASection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32.0),
      decoration: BoxDecoration(
        color: AppTheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: Column(
        children: [
          const Text(
            'Vous êtes un artisan ?',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w600,
              color: AppTheme.onTertiaryContainer,
            ),
          ),
          const SizedBox(height: 8.0),
          const Text(
            'Rejoignez la plus grande communauté de professionnels qualifiés au Burkina Faso et boostez votre visibilité.',
            style: TextStyle(
              color: AppTheme.onTertiaryContainer,
              fontSize: 16.0,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24.0),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.onTertiaryContainer,
              foregroundColor: AppTheme.tertiaryContainer,
              padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            child: const Text(
              "S'inscrire comme Artisan",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Bottom Navigation Bar ─────────────────────────────────

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 12.0,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              _NavItem(icon: Icons.dashboard, label: 'Dashboard', active: true),
              _NavItem(icon: Icons.add_circle_outline, label: 'Ajouter', active: false),
              _NavItem(icon: Icons.inventory_2_outlined, label: 'Mes Offres', active: false),
              _NavItem(icon: Icons.visibility_outlined, label: 'Visibilité', active: false),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  const _NavItem({
    required this.icon,
    required this.label,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
        decoration: BoxDecoration(
          color: active ? AppTheme.primaryContainer : Colors.transparent,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: active ? AppTheme.onPrimaryContainer : AppTheme.onSurfaceVariant,
            ),
            const SizedBox(height: 2.0),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.0,
                color: active ? AppTheme.onPrimaryContainer : AppTheme.onSurfaceVariant,
                fontWeight: active ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}