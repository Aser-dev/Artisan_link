// lib/presentation/pages/artisan/dashboard_artisan_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/commerce_provider.dart';
import '../../widgets/commerce_card.dart';
import 'creer_commerce_page.dart';
import 'gerer_publication_page.dart';
import '../../providers/auth_provider.dart';

class DashboardArtisanPage extends ConsumerStatefulWidget {
  const DashboardArtisanPage({super.key});

  @override
  ConsumerState<DashboardArtisanPage> createState() =>
      _DashboardArtisanPageState();
}

class _DashboardArtisanPageState extends ConsumerState<DashboardArtisanPage> {
  @override
  Widget build(BuildContext context) {
    final mesCommercesAsync = ref.watch(mesCommercesProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        title: const Text(
          'Mes commerces',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.grey),
            onPressed: () {
              ref.read(authProvider.notifier).logout();
              context.go('/login');
            },
          ),
        ],
      ),
      body: mesCommercesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Erreur : $err')),
        data: (commerces) {
          if (commerces.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.storefront, size: 80, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'Aucun commerce enregistré.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Commencez par créer votre première fiche.',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.push('/artisan/creer');
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Créer un commerce'),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: commerces.length,
            itemBuilder: (context, index) {
              final c = commerces[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: Column(
                  children: [
                    CommerceCard(commerce: c),
                    Row(
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            context.push('/artisan/editer/${c.id}');
                          },
                          icon: const Icon(Icons.edit, size: 16),
                          label: const Text('Modifier'),
                        ),
                        const SizedBox(width: 8),
                        TextButton.icon(
                          onPressed: () {
                            context.push(
                              '/artisan/publication/${c.id}',
                              extra: c.estPublie,
                            );
                          },
                          icon: Icon(
                            c.estPublie
                                ? Icons.visibility
                                : Icons.visibility_off,
                            size: 16,
                            color: c.estPublie ? Colors.green : Colors.red,
                          ),
                          label: Text(
                            c.estPublie ? 'Publié' : 'Brouillon',
                            style: TextStyle(
                              color: c.estPublie ? Colors.green : Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/artisan/creer');
        },
        backgroundColor: const Color(0xFF8CD82C),
        child: const Icon(Icons.add, color: Color(0xFF1E1E1E)),
      ),
    );
  }
}
