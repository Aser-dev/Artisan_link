// lib/presentation/pages/citoyen/liste_recherche_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/commerce_provider.dart';
import '../../widgets/commerce_card.dart';
import 'detail_commerce_page.dart';
import '../../../core/constants.dart';

class ListeRecherchePage extends ConsumerStatefulWidget {
  const ListeRecherchePage({super.key});

  @override
  ConsumerState<ListeRecherchePage> createState() => _ListeRecherchePageState();
}

class _ListeRecherchePageState extends ConsumerState<ListeRecherchePage> {
  final _searchController = TextEditingController();
  String _query = '';
  String? _categorieFiltre;
  double? _noteFiltre;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final commerceState = ref.watch(commerceProvider);
    final commerces = commerceState.commerces;

    final filtered = commerces.where((c) {
      final matchNom = c.nom.toLowerCase().contains(_query.toLowerCase());
      final matchCat =
          _categorieFiltre == null || c.categorie == _categorieFiltre;
      final matchNote = _noteFiltre == null || c.noteMoyenne >= _noteFiltre!;
      return matchNom && matchCat && matchNote;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: (v) => setState(() => _query = v),
                  decoration: InputDecoration(
                    hintText: 'Rechercher un artisan...',
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: _query.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 16),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _query = '');
                            },
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFiltreCategorie('Tous', null),
                      ...AppConstants.categories.map(
                        (cat) => _buildFiltreCategorie(cat, cat),
                      ),
                      const SizedBox(width: 8),
                      _buildFiltreNote(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: commerceState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : filtered.isEmpty
                ? const Center(
                    child: Text(
                      'Aucun artisan trouvé.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final c = filtered[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  DetailCommercePage(commerceId: c.id),
                            ),
                          );
                        },
                        child: CommerceCard(commerce: c),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltreCategorie(String label, String? value) {
    final selected = _categorieFiltre == value;
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (s) {
          setState(() => _categorieFiltre = s ? value : null);
          ref
              .read(commerceProvider.notifier)
              .filtrerParCategorie(_categorieFiltre);
        },
        selectedColor: const Color(0xFF8CD82C),
        backgroundColor: Colors.white,
      ),
    );
  }

  Widget _buildFiltreNote() {
    return PopupMenuButton<double>(
      icon: const Icon(Icons.star, color: Colors.amber, size: 20),
      tooltip: 'Filtrer par note',
      onSelected: (value) {
        setState(() => _noteFiltre = value);
        ref.read(commerceProvider.notifier).filtrerParNote(value);
      },
      itemBuilder: (context) => const [
        PopupMenuItem(value: null, child: Text('Toutes les notes')),
        PopupMenuItem(value: 4.0, child: Text('⭐ 4 et +')),
        PopupMenuItem(value: 3.0, child: Text('⭐ 3 et +')),
        PopupMenuItem(value: 2.0, child: Text('⭐ 2 et +')),
      ],
    );
  }
}
