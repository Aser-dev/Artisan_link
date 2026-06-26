// Cette widget réutilisable affiche un commerce (nom/catégorie) dans une carte.

import 'package:flutter/material.dart';

import '../../domain/entities/commerce_entity.dart';

class CommerceCard extends StatelessWidget {
  final CommerceEntity commerce;
  final VoidCallback? onTap;

  const CommerceCard({super.key, required this.commerce, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                commerce.name,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 6),
              Text(
                commerce.category,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
