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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE9ECEF)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          // Thumb photo / icône
          ClipRRect(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), bottomLeft: Radius.circular(16)),
            child: commerce.photos.isNotEmpty
                ? Image.network(
                    commerce.photos.first,
                    width: 88,
                    height: 88,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _iconBox(),
                  )
                : _iconBox(),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          commerce.nom,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E1E1E)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          commerce.categorie,
                          style: const TextStyle(fontSize: 11, color: Color(0xFF2E4A0B), fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      RatingStars(rating: commerce.noteMoyenne, size: 13),
                      const SizedBox(width: 6),
                      Text(
                        '${commerce.noteMoyenne.toStringAsFixed(1)} (${commerce.nombreAvis})',
                        style: const TextStyle(fontSize: 12, color: Color(0xFF6C757D)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.chevron_right_rounded, color: Color(0xFFCED4DA), size: 22),
          ),
        ],
      ),
    );
  }

  Widget _iconBox() {
    return Container(
      width: 88,
      height: 88,
      color: const Color(0xFFF1F3F5),
      child: Icon(_getIcon(commerce.categorie), size: 36, color: const Color(0xFF5A6B5C)),
    );
  }

  IconData _getIcon(String categorie) {
    switch (categorie.toLowerCase()) {
      case 'mécanicien': return Icons.build_rounded;
      case 'couturier': return Icons.checkroom_rounded;
      case 'coiffeur': return Icons.content_cut_rounded;
      case 'soudeur': return Icons.hardware_rounded;
      case 'électricien': return Icons.electrical_services_rounded;
      default: return Icons.storefront_rounded;
    }
  }
}
