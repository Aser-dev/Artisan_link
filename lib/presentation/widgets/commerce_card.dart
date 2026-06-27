// lib/presentation/widgets/commerce_card.dart
import 'package:flutter/material.dart';
import '../../domain/entities/commerce_entity.dart';
import 'rating_stars.dart';

class CommerceCard extends StatelessWidget {
  final CommerceEntity commerce;
  const CommerceCard({super.key, required this.commerce});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE9ECEF)),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F3F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(_getIcon(commerce.categorie), size: 32, color: const Color(0xFF5A6B5C)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(commerce.nom, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(commerce.categorie, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    RatingStars(rating: commerce.noteMoyenne, size: 14),
                    const SizedBox(width: 4),
                    Text('${commerce.noteMoyenne.toStringAsFixed(1)} (${commerce.nombreAvis})',
                        style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: commerce.estPublie ? Colors.green[50] : Colors.red[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        commerce.estPublie ? 'Ouvert' : 'Fermé',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: commerce.estPublie ? Colors.green[700] : Colors.red[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIcon(String categorie) {
    switch (categorie.toLowerCase()) {
      case 'mécanicien': return Icons.build;
      case 'couturier': return Icons.checkroom;
      case 'coiffeur': return Icons.content_cut;
      case 'soudeur': return Icons.hardware;
      case 'électricien': return Icons.electrical_services;
      default: return Icons.storefront;
    }
  }
}