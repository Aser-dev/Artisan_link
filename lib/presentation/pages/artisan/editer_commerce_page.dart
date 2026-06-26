// Cette page permet à l’artisan d’éditer un commerce.

import 'package:flutter/material.dart';

class EditeurCommercePage extends StatelessWidget {
  const EditeurCommercePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Éditer un commerce'),
      ),
      body: const Center(
        child: Text(
          'editer_commerce_page à implémenter (appeler UpdateCommerceUsecase)',
        ),
      ),
    );
  }
}

