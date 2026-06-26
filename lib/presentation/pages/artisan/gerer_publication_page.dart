// Cette page permet à l’artisan de gérer la publication (activer/désactiver).

import 'package:flutter/material.dart';

class GererPublicationPage extends StatelessWidget {
  const GererPublicationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gérer la publication'),
      ),
      body: const Center(
        child: Text(
          'gerer_publication_page à implémenter (appeler toggle_publication_usecase)',
        ),
      ),
    );
  }
}

