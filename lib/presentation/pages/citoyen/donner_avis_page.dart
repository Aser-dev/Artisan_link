// Cette page permet à l’utilisateur de soumettre un avis.

import 'package:flutter/material.dart';

class DonnerAvisPage extends StatelessWidget {
  const DonnerAvisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Donner un avis'),
      ),
      body: const Center(
        child: Text(
          'donner_avis_page à implémenter (appeler submit_avis_usecase)',
        ),
      ),
    );
  }
}

