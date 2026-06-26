// Cette page est l’accueil pour les citoyens.

import 'package:flutter/material.dart';

class AccueilCitoyenPage extends StatelessWidget {
  const AccueilCitoyenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accueil citoyen'),
      ),
      body: const Center(
        child: Text(
          'accueil_citoyen_page à implémenter (appeler get_nearby_commerces_usecase)',
        ),
      ),
    );
  }
}

