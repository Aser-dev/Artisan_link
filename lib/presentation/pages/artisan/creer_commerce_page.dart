// Cette page permet à l’artisan de créer un commerce.

import 'package:flutter/material.dart';

class CreerCommercePage extends StatelessWidget {
  const CreerCommercePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Créer un commerce')),
      body: const Center(
        child: Text(
          'creer_commerce_page à implémenter (appeler CreateCommerceUsecase)',
        ),
      ),
    );
  }
}
