// lib/presentation/pages/citoyen/accueil_citoyen_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../../core/theme/app_theme.dart';
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
  void dispose() { _tabController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    final prenom = user?.nom.split(' ').first ?? '';

    return Scaffold(
      backgroundColor: AppTheme.neutralSand,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceContainerLow,
        toolbarHeight: 68,
        titleSpacing: 16,
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(prenom.isNotEmpty ? 'Bonjour, $prenom 👋' : 'Bonjour 👋', style: const TextStyle(fontSize: 12, color: AppTheme.onSurfaceVariant, fontWeight: FontWeight.normal, fontFamily: 'Be Vietnam Pro')),
          const Text('Artisan Core', style: TextStyle(fontFamily: 'Hanken Grotesk', fontSize: 20, fontWeight: FontWeight.w700)),
        ]),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () { ref.read(authProvider.notifier).logout(); context.go('/login'); },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: AppTheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.logout_rounded, color: AppTheme.onSurfaceVariant, size: 20),
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            color: AppTheme.surfaceContainerLow,
            child: TabBar(
              controller: _tabController,
              indicatorColor: AppTheme.primary,
              indicatorWeight: 3,
              labelColor: AppTheme.primary,
              unselectedLabelColor: AppTheme.onSurfaceVariant,
              labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, fontFamily: 'Be Vietnam Pro'),
              tabs: const [
                Tab(text: 'Carte', icon: Icon(Icons.map_outlined, size: 18)),
                Tab(text: 'Liste', icon: Icon(Icons.list_alt_outlined, size: 18)),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(controller: _tabController, children: const [CartePage(), ListeRecherchePage()]),
    );
  }
}
