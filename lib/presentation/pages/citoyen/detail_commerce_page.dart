// Cette page affiche les détails d’un commerce (appel get_commerce_by_id_usecase).

import 'package:flutter/material.dart';

class DetailCommercePage extends StatelessWidget {
  const DetailCommercePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails du commerce'),
      ),
      body: const Center(
        child: Text(
          'detail_commerce_page à implémenter (appeler get_commerce_by_id_usecase)',
        ),
      ),
    );
  }
}

