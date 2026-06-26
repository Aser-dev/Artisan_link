// Cette page affiche les résultats de recherche des commerces.

import 'package:flutter/material.dart';

class ListeRecherchePage extends StatelessWidget {
  const ListeRecherchePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recherche'),
      ),
      body: const Center(
        child: Text(
          'liste_recherche_page à implémenter (appeler get_nearby_commerces_usecase)',
        ),
      ),
    );
  }
}

