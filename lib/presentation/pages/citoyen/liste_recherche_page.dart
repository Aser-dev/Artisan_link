import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/commerce_provider.dart';
import '../../widgets/commerce_card.dart';
import '../../../core/constants.dart';
import '../../../core/services/location_service.dart';
import '../../../core/theme/app_theme.dart';
import 'detail_commerce_page.dart';

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
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final commerceState = ref.watch(commerceProvider);
    final filtered = commerceState.commerces.where((c) {
      final matchNom = c.nom.toLowerCase().contains(_query.toLowerCase());
      final matchCat = _categorieFiltre == null || c.categorie == _categorieFiltre;
      final matchNote = _noteFiltre == null || c.noteMoyenne >= _noteFiltre!;
      return matchNom && matchCat && matchNote;
    }).toList();

    return Scaffold(
      backgroundColor: AppTheme.neutralSand,
      body: Column(
        children: [
          // Barre recherche + filtres
          Container(
            color: AppTheme.neutralSand,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Column(
              children: [
                // Champ recherche
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.outlineVariant.withValues(alpha: 0.3)),
                    boxShadow: [BoxShadow(color: AppTheme.primary.withValues(alpha: 0.04), blurRadius: 8)],
                  ),
                  child: TextField(
                    controller: _searchCtrl,
                    onChanged: (v) => setState(() => _query = v),
                    decoration: InputDecoration(
                      hintText: 'Rechercher un artisan...',
                      hintStyle: const TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 14),
                      prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.onSurfaceVariant, size: 20),
                      suffixIcon: _query.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded, size: 18, color: AppTheme.onSurfaceVariant),
                              onPressed: () { _searchCtrl.clear(); setState(() => _query = ''); })
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Chips catégories
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildChip('Tous', null),
                      ...AppConstants.categories.map((cat) => _buildChip(cat, cat)),
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
                ? const Center(child: CircularProgressIndicator(color: AppTheme.primary))
                : filtered.isEmpty
                ? Center(
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Container(
                        width: 72, height: 72,
                        decoration: BoxDecoration(color: AppTheme.surfaceContainerHigh, borderRadius: BorderRadius.circular(20)),
                        child: const Icon(Icons.search_off_rounded, size: 36, color: AppTheme.outlineVariant),
                      ),
                      const SizedBox(height: 16),
                      const Text('Aucun artisan trouvé.', style: TextStyle(fontFamily: 'Hanken Grotesk', fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.onSurface)),
                      const SizedBox(height: 4),
                      const Text('Essayez un autre mot-clé ou catégorie.', style: TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 13)),
                    ]),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    itemCount: filtered.length,
                    itemBuilder: (context, i) {
                      final c = filtered[i];
                      return GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetailCommercePage(commerceId: c.id))),
                        child: CommerceCard(commerce: c),
                      );
                    },
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
          setState(() => _categorieFiltre = selected ? null : value);
          ref.read(commerceProvider.notifier).filtrerParCategorie(selected ? null : value);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: selected ? AppTheme.primary : AppTheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: selected ? AppTheme.primary : AppTheme.outlineVariant.withValues(alpha: 0.5)),
          ),
          child: Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: selected ? AppTheme.onPrimary : AppTheme.onSurfaceVariant)),
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: _noteFiltre != null ? AppTheme.savannahGold.withValues(alpha: 0.15) : AppTheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: _noteFiltre != null ? AppTheme.savannahGold : AppTheme.outlineVariant.withValues(alpha: 0.5)),
        ),
        child: Row(children: [
          Icon(Icons.star_rounded, color: _noteFiltre != null ? AppTheme.savannahGold : AppTheme.onSurfaceVariant, size: 16),
          const SizedBox(width: 4),
          Text(_noteFiltre != null ? '${_noteFiltre!.toInt()}+' : 'Note', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _noteFiltre != null ? AppTheme.savannahGold : AppTheme.onSurfaceVariant)),
        ]),
      ),
    );
  }
}
