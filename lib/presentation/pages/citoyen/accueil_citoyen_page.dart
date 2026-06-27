// lib/presentation/pages/citoyen/accueil_citoyen_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
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
    final user = ref.watch(authProvider).user;
    final prenom = user?.nom.split(' ').first ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 70,
        titleSpacing: 20,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              prenom.isNotEmpty ? 'Bonjour, $prenom 👋' : 'Bonjour 👋',
              style: const TextStyle(fontSize: 13, color: Color(0xFF6C757D), fontWeight: FontWeight.normal),
            ),
            const Text(
              'ArtisanBF',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2E4A0B)),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {
                ref.read(authProvider.notifier).logout();
                context.go('/login');
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F3F5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.logout_rounded, color: Color(0xFF6C757D), size: 20),
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: const Color(0xFF8CD82C),
              indicatorWeight: 3,
              labelColor: const Color(0xFF1E1E1E),
              unselectedLabelColor: const Color(0xFF6C757D),
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              tabs: const [
                Tab(text: 'Carte', icon: Icon(Icons.map_outlined, size: 18)),
                Tab(text: 'Liste', icon: Icon(Icons.list_alt_outlined, size: 18)),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [CartePage(), ListeRecherchePage()],
      ),
    );
  }
}
