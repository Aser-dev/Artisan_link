// lib/presentation/pages/citoyen/accueil_citoyen_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'carte_page.dart';
import 'liste_recherche_page.dart';

class AccueilCitoyenPage extends ConsumerStatefulWidget {
  const AccueilCitoyenPage({super.key});

  @override
  ConsumerState<AccueilCitoyenPage> createState() => _AccueilCitoyenPageState();
}

class _AccueilCitoyenPageState extends ConsumerState<AccueilCitoyenPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        title: const Text(
          'ArtisanBF',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E4A0B),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.grey),
            onPressed: () {},
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF8CD82C),
          labelColor: const Color(0xFF1E1E1E),
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'Carte', icon: Icon(Icons.map_outlined)),
            Tab(text: 'Liste', icon: Icon(Icons.list_alt_outlined)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [CartePage(), ListeRecherchePage()],
      ),
    );
  }
}
