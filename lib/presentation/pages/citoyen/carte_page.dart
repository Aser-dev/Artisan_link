// lib/presentation/pages/citoyen/carte_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/services/location_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/commerce_provider.dart';
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

  // Liste des catégories avec icônes
  final List<Map<String, dynamic>> _categories = [
    {'label': 'Tout', 'icon': Icons.all_inclusive},
    {'label': 'Mécaniciens', 'icon': Icons.build},
    {'label': 'Couturiers', 'icon': Icons.dry_cleaning},
    {'label': 'Menuisiers', 'icon': Icons.handyman},
    {'label': 'Ferronniers', 'icon': Icons.iron},
    {'label': 'Électriciens', 'icon': Icons.electrical_services},
  ];

  // Commerce sélectionné pour la bottom sheet
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
    setState(() {
      _selectedCommerce = commerce;
    });
  }

  void _closeBottomSheet() {
    setState(() {
      _selectedCommerce = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final commerceState = ref.watch(commerceProvider);
    final commerces = commerceState.commerces;

    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppTheme.background,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        backgroundColor: AppTheme.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(_errorMessage!),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadData,
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      );
    }

    // Filtrer les commerces par catégorie
    final filteredCommerces = _selectedCategory == 'Tout'
        ? commerces
        : commerces.where((c) => c.categorie == _selectedCategory).toList();

    // Construction des marqueurs
    final markers = filteredCommerces.where((c) => c.aPosition).map((c) {
      return Marker(
        width: 80,
        height: 80,
        point: LatLng(c.latitude!, c.longitude!),
        alignment: Alignment.center,
        child: _buildMarker(c),
      );
    }).toList();

    // Marqueur de la position de l'utilisateur
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
            decoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.my_location, color: Colors.white, size: 16),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
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
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.artisan_bf',
              ),
              MarkerLayer(markers: markers),
            ],
          ),

          // Interface utilisateur flottante
          SafeArea(
            child: Column(
              children: [
                // Barre de recherche et filtres
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildSearchBar(),
                      const SizedBox(height: 12),
                      _buildCategoryFilters(),
                    ],
                  ),
                ),
                const Spacer(),
                // Bouton de localisation
                Padding(
                  padding: const EdgeInsets.only(right: 16.0, bottom: 16.0),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton(
                      mini: true,
                      backgroundColor: AppTheme.surface,
                      onPressed: _loadData,
                      child: const Icon(
                        Icons.my_location,
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom Sheet des détails
          if (_selectedCommerce != null) _buildDetailBottomSheet(),
        ],
      ),
    );
  }

  // ─── Barre de recherche ──────────────────────────────────

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(color: AppTheme.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 16),
            child: Icon(Icons.search, color: AppTheme.onSurfaceVariant),
          ),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Rechercher un ferronnier, mécanicien...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
              onSubmitted: (value) {
                // Lancer la recherche
                ref.read(commerceProvider.notifier).rechercher(query: value);
              },
            ),
          ),
          IconButton(
            onPressed: () {
              // Ouvrir les filtres avancés
            },
            icon: const Icon(Icons.tune, color: AppTheme.primary),
          ),
        ],
      ),
    );
  }

  // ─── Filtres par catégorie ──────────────────────────────

  Widget _buildCategoryFilters() {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = _categories[index];
          final isSelected = _selectedCategory == cat['label'];
          return FilterChip(
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(cat['icon'] as IconData, size: 18),
                const SizedBox(width: 6),
                Text(cat['label'] as String),
              ],
            ),
            selected: isSelected,
            onSelected: (_) {
              setState(() {
                _selectedCategory = cat['label'] as String;
              });
              // Mettre à jour le filtre dans le provider
              ref
                  .read(commerceProvider.notifier)
                  .filtrerParCategorie(
                    _selectedCategory == 'Tout' ? null : _selectedCategory,
                  );
            },
            showCheckmark: false,
            selectedColor: AppTheme.primary,
            labelStyle: TextStyle(
              color: isSelected
                  ? AppTheme.onPrimary
                  : AppTheme.onSurfaceVariant,
            ),
            backgroundColor: AppTheme.surface,
            side: BorderSide(
              color: isSelected ? Colors.transparent : AppTheme.outlineVariant,
              width: 1,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          );
        },
      ),
    );
  }

  // ─── Marqueur personnalisé ──────────────────────────────

  Widget _buildMarker(dynamic commerce) {
    return GestureDetector(
      onTap: () => _selectCommerce(commerce),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.primary,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Icon(
                _getCategoryIcon(commerce.categorie),
                color: AppTheme.onPrimary,
                size: 20,
              ),
            ),
          ),
          if (_selectedCommerce == commerce) ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1A000000),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    commerce.nom,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primary,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: AppTheme.savannahGold,
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        commerce.noteMoyenne.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
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
        return Icons.build;
      case 'couturier':
        return Icons.dry_cleaning;
      case 'menuiserie':
      case 'menuisier':
        return Icons.handyman;
      case 'ferronnier':
      case 'soudeur':
        return Icons.iron;
      case 'électricien':
        return Icons.electrical_services;
      default:
        return Icons.storefront;
    }
  }

  // ─── Bottom Sheet Détails ──────────────────────────────

  Widget _buildDetailBottomSheet() {
    final c = _selectedCommerce;
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: GestureDetector(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 30,
                offset: Offset(0, -8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.outlineVariant.withValues(alpha: 0.5),
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
                      width: 80,
                      height: 80,
                      color: AppTheme.surfaceVariant,
                      child: c.photos.isNotEmpty
                          ? Image.network(c.photos.first, fit: BoxFit.cover)
                          : const Icon(Icons.image, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          c.categorie.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.terracottaClay,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          c.nom,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 14,
                              color: AppTheme.outline,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              c.descriptionAdresse ?? 'Adresse non renseignée',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppTheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.savannahGold.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: AppTheme.savannahGold,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          c.noteMoyenne.toStringAsFixed(1),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
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
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Appeler l'artisan
                      },
                      icon: const Icon(Icons.call),
                      label: const Text('Appeler'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        foregroundColor: AppTheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Envoyer un message / chat
                      },
                      icon: const Icon(Icons.chat_bubble),
                      label: const Text('Message'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryContainer,
                        foregroundColor: AppTheme.onPrimaryContainer,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailCommercePage(commerceId: c.id),
                    ),
                  );
                },
                child: const Text('Voir plus de détails →'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
