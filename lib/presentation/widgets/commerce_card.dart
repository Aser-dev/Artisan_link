import 'package:flutter/material.dart';

import '../../domain/entities/commerce_entity.dart';

class CommerceCard extends StatelessWidget {
  final CommerceEntity commerce;

  const CommerceCard({super.key, required this.commerce});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(commerce.name),
        subtitle: Text(commerce.category),
      ),
    );
  }
}

