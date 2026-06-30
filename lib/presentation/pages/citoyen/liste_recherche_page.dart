// lib/presentation/pages/citoyen/liste_recherche_page.dart
// Page de recherche et filtrage des commerces par nom, catégorie, note
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/commerce_provider.dart';
import '../../../core/constants.dart';
import '../../../core/services/location_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/commerce_card.dart';
import '../../widgets/design_system.dart';
import '../../widgets/skeletons.dart';

final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});

class ListeRecherchePage extends ConsumerStatefulWidget {
  const ListeRecherchePage({super.key});

  @override
  ConsumerState<ListeRecherchePage> createState() => _ListeRecherchePageState();
}

class _ListeRecherchePageState extends ConsumerState<ListeRecherchePage> {
  final _searchCtrl = TextEditingController();
  String _query = '';
  String? _categorieFiltre;
  double? _noteFiltre;

  @override
  void initState() {
    super.initState();
    _loadCommerces();
  }

  Future<void> _loadCommerces() async {
    try {
      final location = ref.read(locationServiceProvider);
      final position = await location.getCurrentPositionWithFallback();
      if (!mounted) return;
      await ref.read(commerceProvider.notifier).chargerProches(
            latitude: position.latitude,
            longitude: position.longitude,
          );
    } catch (_) {}
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final commerceState = ref.watch(commerceProvider);
    final filtered = commerceState.commerces.where((c) {
      final matchNom = c.nom.toLowerCase().contains(_query.toLowerCase());
      final matchCat =
          _categorieFiltre == null || c.categorie == _categorieFiltre;
      final matchNote = _noteFiltre == null || c.noteMoyenne >= _noteFiltre!;
      return matchNom && matchCat && matchNote;
    }).toList();

    return Scaffold(
      backgroundColor: AppTheme.fondPrincipal,
      body: Column(
        children: [
          Container(
            color: AppTheme.fondPrincipal,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Column(
              children: [
                // Barre recherche
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceCard,
                    borderRadius: BorderRadius.circular(99),
                    border: Border.all(color: AppTheme.bordureSubtile),
                  ),
                  child: TextField(
                    controller: _searchCtrl,
                    onChanged: (v) => setState(() => _query = v),
                    style: GoogleFonts.inter(
                        fontSize: 14, color: AppTheme.textePrimaire),
                    decoration: InputDecoration(
                      hintText: 'Rechercher un artisan...',
                      prefixIcon: const Icon(Icons.search_rounded,
                          color: AppTheme.texteSecondaire, size: 20),
                      suffixIcon: _query.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded,
                                  size: 18,
                                  color: AppTheme.texteSecondaire),
                              onPressed: () {
                                _searchCtrl.clear();
                                setState(() => _query = '');
                              })
                          : null,
                      border: InputBorder.none,
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Filtres
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildChip('Tous', null),
                      ...AppConstants.categories
                          .map((cat) => _buildChip(cat, cat)),
                      const SizedBox(width: 8),
                      _buildNoteFilter(),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Résultats
          Expanded(
            child: commerceState.isLoading
                ? ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    itemCount: 3,
                    itemBuilder: (_, _) => const SkeletonCard(),
                  )
                : filtered.isEmpty
                    ? EmptyState(
                        icon: Icons.search_off_rounded,
                        title: 'Aucun artisan trouvé.',
                        subtitle:
                            'Essayez un autre mot-clé ou catégorie.',
                        actionLabel: 'Réinitialiser',
                        onAction: () {
                          setState(() {
                            _query = '';
                            _categorieFiltre = null;
                            _noteFiltre = null;
                            _searchCtrl.clear();
                          });
                          ref
                              .read(commerceProvider.notifier)
                              .filtrerParCategorie(null);
                        },
                      )
                    : RefreshIndicator(
                        color: AppTheme.accentPrimaire,
                        onRefresh: _loadCommerces,
                        child: ListView.builder(
                          padding:
                              const EdgeInsets.fromLTRB(16, 8, 16, 16),
                          itemCount: filtered.length,
                          itemBuilder: (context, i) {
                            final c = filtered[i];
                            return GestureDetector(
                              onTap: () => context.push(
                                  '/citoyen/detail/${c.id}'),
                              child: CommerceCard(commerce: c),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label, String? value) {
    final selected = _categorieFiltre == value;
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: GestureDetector(
        onTap: () {
          setState(
              () => _categorieFiltre = selected ? null : value);
          ref
              .read(commerceProvider.notifier)
              .filtrerParCategorie(selected ? null : value);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: selected
                ? AppTheme.accentSecondaire
                : AppTheme.surfaceCard,
            borderRadius: BorderRadius.circular(99),
            border: Border.all(
              color: selected
                  ? AppTheme.accentPrimaire
                  : AppTheme.bordureSubtile,
            ),
          ),
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: selected
                  ? AppTheme.accentPrimaire
                  : AppTheme.texteSecondaire,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNoteFilter() {
    return PopupMenuButton<double?>(
      tooltip: 'Filtrer par note',
      onSelected: (v) {
        setState(() => _noteFiltre = v);
        ref.read(commerceProvider.notifier).filtrerParNote(v ?? 0);
      },
      itemBuilder: (_) => [
        const PopupMenuItem(value: null, child: Text('Toutes les notes')),
        const PopupMenuItem(value: 4.0, child: Text('⭐ 4 et +')),
        const PopupMenuItem(value: 3.0, child: Text('⭐ 3 et +')),
        const PopupMenuItem(value: 2.0, child: Text('⭐ 2 et +')),
      ],
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: _noteFiltre != null
              ? AppTheme.accentSecondaire.withValues(alpha: 0.2)
              : AppTheme.surfaceCard,
          borderRadius: BorderRadius.circular(99),
          border: Border.all(
            color: _noteFiltre != null
                ? AppTheme.accentPrimaire
                : AppTheme.bordureSubtile,
          ),
        ),
        child: Row(children: [
          Icon(
            Icons.star_rounded,
            color: _noteFiltre != null
                ? AppTheme.accentPrimaire
                : AppTheme.texteSecondaire,
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            _noteFiltre != null ? '${_noteFiltre!.toInt()}+' : 'Note',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: _noteFiltre != null
                  ? AppTheme.accentPrimaire
                  : AppTheme.texteSecondaire,
            ),
          ),
        ]),
      ),
    );
  }
}