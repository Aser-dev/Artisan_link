// Cette page affiche la carte des commerces (utiliser flutter_map).

import 'package:flutter/material.dart';

class CartePage extends StatelessWidget {
  const CartePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carte des commerces'),
      ),
      body: const Center(
        child: Text(
          'carte_page à implémenter (flutter_map + données get_nearby_commerces)',
        ),
      ),
    );
  }
}

