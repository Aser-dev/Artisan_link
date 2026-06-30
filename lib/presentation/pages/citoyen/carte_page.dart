// lib/presentation/pages/citoyen/carte_page.dart
// Carte interactive OpenStreetMap pour visualiser les commerces à proximité
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import '../../../core/services/location_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/commerce_provider.dart';
import '../../widgets/skeletons.dart';
import '../../widgets/design_system.dart';
import 'detail_commerce_page.dart';

class CartePage extends ConsumerStatefulWidget {
  const CartePage({super.key});

  @override
  ConsumerState<CartePage> createState() => _CartePageState();
}

class _CartePageState extends ConsumerState<CartePage> {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  final LocationService _locationService = LocationService();

  String _selectedCategory = 'Tout';
  LatLng? _userPosition;
  bool _isLoading = true;
  String? _errorMessage;

  final List<Map<String, dynamic>> _categories = [
    {'label': 'Tout', 'icon': Icons.all_inclusive},
    {'label': 'Mécaniciens', 'icon': Icons.build_rounded},
    {'label': 'Couturiers', 'icon': Icons.checkroom_rounded},
    {'label': 'Menuisiers', 'icon': Icons.handyman_rounded},
    {'label': 'Ferronniers', 'icon': Icons.iron},
    {'label': 'Électriciens', 'icon': Icons.electrical_services_rounded},
  ];

  dynamic _selectedCommerce;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final position = await _locationService.getCurrentPositionWithFallback();
      _userPosition = LatLng(position.latitude, position.longitude);

      await ref
          .read(commerceProvider.notifier)
          .chargerProches(
            latitude: position.latitude,
            longitude: position.longitude,
          );

      setState(() => _isLoading = false);
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  void _selectCommerce(dynamic commerce) {
    HapticFeedback.lightImpact();
    setState(() => _selectedCommerce = commerce);
  }

  void _closeBottomSheet() {
    setState(() => _selectedCommerce = null);
  }

  @override
  Widget build(BuildContext context) {
    final commerceState = ref.watch(commerceProvider);
    final commerces = commerceState.commerces;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppTheme.fondPrincipal,
        body: const SkeletonMap(),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        backgroundColor: AppTheme.fondPrincipal,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppTheme.erreur),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                style: GoogleFonts.inter(color: AppTheme.texteSecondaire),
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                label: 'Réessayer',
                onPressed: _loadData,
                icon: Icons.refresh_rounded,
              ),
            ],
          ),
        ),
      );
    }

    final filteredCommerces = _selectedCategory == 'Tout'
        ? commerces
        : commerces.where((c) => c.categorie == _selectedCategory).toList();

    final markers = filteredCommerces.where((c) => c.aPosition).map((c) {
      return Marker(
        width: 80,
        height: 80,
        point: LatLng(c.latitude!, c.longitude!),
        alignment: Alignment.center,
        child: _buildMarker(c),
      );
    }).toList();

    if (_userPosition != null) {
      markers.add(
        Marker(
          width: 30,
          height: 30,
          point: _userPosition!,
          alignment: Alignment.center,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: AppTheme.accentPrimaire,
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.fondPrincipal, width: 3),
            ),
            child: const Icon(Icons.my_location,
                color: Color(0xFF0F0F0F), size: 12),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.fondPrincipal,
      body: Stack(
        children: [
          // Carte
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _userPosition ?? const LatLng(12.3714, -1.5347),
              initialZoom: 14.0,
              onTap: (_, _) => _closeBottomSheet(),
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.artisan_bf',
              ),
              MarkerLayer(markers: markers),
            ],
          ),

          // Interface flottante
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildSearchBar(),
                      const SizedBox(height: 12),
                      _buildCategoryFilters(),
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 16, bottom: 16),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton(
                      mini: true,
                      backgroundColor: AppTheme.surfaceCard,
                      onPressed: _loadData,
                      child: const Icon(
                        Icons.my_location,
                        color: AppTheme.accentPrimaire,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          if (_selectedCommerce != null) _buildDetailBottomSheet(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: AppTheme.bordureSubtile),
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 16),
            child: Icon(Icons.search,
                color: AppTheme.texteSecondaire, size: 20),
          ),
          Expanded(
            child: TextField(
              controller: _searchController,
              style: GoogleFonts.inter(
                  fontSize: 14, color: AppTheme.textePrimaire),
              decoration: InputDecoration(
                hintText: 'Rechercher un artisan...',
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
              onSubmitted: (value) {
                ref
                    .read(commerceProvider.notifier)
                    .rechercher(query: value);
              },
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.tune,
                color: AppTheme.accentPrimaire, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilters() {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = _categories[index];
          final isSelected = _selectedCategory == cat['label'];
          return GestureDetector(
            onTap: () {
              setState(() => _selectedCategory = cat['label'] as String);
              ref
                  .read(commerceProvider.notifier)
                  .filtrerParCategorie(
                    _selectedCategory == 'Tout'
                        ? null
                        : _selectedCategory,
                  );
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.accentSecondaire
                    : AppTheme.surfaceCard,
                borderRadius: BorderRadius.circular(99),
                border: Border.all(
                  color: isSelected
                      ? AppTheme.accentPrimaire
                      : AppTheme.bordureSubtile,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(cat['icon'] as IconData,
                      size: 16,
                      color: isSelected
                          ? AppTheme.accentPrimaire
                          : AppTheme.texteSecondaire),
                  const SizedBox(width: 6),
                  Text(
                    cat['label'] as String,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? AppTheme.accentPrimaire
                          : AppTheme.texteSecondaire,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMarker(dynamic commerce) {
    return GestureDetector(
      onTap: () => _selectCommerce(commerce),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppTheme.accentPrimaire,
              shape: BoxShape.circle,
              border:
                  Border.all(color: AppTheme.fondPrincipal, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Icon(
                _getCategoryIcon(commerce.categorie),
                color: const Color(0xFF0F0F0F),
                size: 20,
              ),
            ),
          ),
          if (_selectedCommerce == commerce) ...[
            const SizedBox(height: 4),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.surfaceCard,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.bordureSubtile),
              ),
              child: Column(
                children: [
                  Text(
                    commerce.nom,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.accentPrimaire,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star,
                          color: Color(0xFF8CD82C), size: 10),
                      const SizedBox(width: 2),
                      Text(
                        commerce.noteMoyenne.toStringAsFixed(1),
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textePrimaire,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'mécanicien':
        return Icons.build_rounded;
      case 'couturier':
        return Icons.checkroom_rounded;
      case 'menuiserie':
      case 'menuisier':
        return Icons.handyman_rounded;
      case 'ferronnier':
      case 'soudeur':
        return Icons.iron;
      case 'électricien':
        return Icons.electrical_services_rounded;
      default:
        return Icons.storefront_rounded;
    }
  }

  Widget _buildDetailBottomSheet() {
    final c = _selectedCommerce;
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: GestureDetector(
        onTap: () => context.push('/citoyen/detail/${c.id}'),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.surfaceCard,
            borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24)),
            border: Border(
              top: BorderSide(
                  color: AppTheme.bordureSubtile, width: 0.5),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.texteTertiaire,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 72,
                      height: 72,
                      color: AppTheme.surfaceCardHover,
                      child: c.photos.isNotEmpty
                          ? Image.network(c.photos.first,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => const Icon(
                                  Icons.image,
                                  color: AppTheme.texteTertiaire))
                          : const Icon(Icons.image,
                              color: AppTheme.texteTertiaire),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          c.categorie.toUpperCase(),
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.accentPrimaire,
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          c.nom,
                          style: GoogleFonts.inter(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textePrimaire,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on,
                                size: 13,
                                color: AppTheme.texteSecondaire),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                c.descriptionAdresse ??
                                    'Adresse non renseignée',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: AppTheme.texteSecondaire,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.accentSecondaire
                          .withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star,
                            color: Color(0xFF8CD82C), size: 12),
                        const SizedBox(width: 4),
                        Text(
                          c.noteMoyenne.toStringAsFixed(1),
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: AppTheme.textePrimaire,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: PrimaryButton(
                      label: 'Voir détails',
                      onPressed: () =>
                          context.push('/citoyen/detail/${c.id}'),
                      icon: Icons.info_outline_rounded,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}