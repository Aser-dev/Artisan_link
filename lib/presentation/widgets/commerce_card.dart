// lib/presentation/widgets/commerce_card.dart
import 'package:flutter/material.dart';
import '../../domain/entities/commerce_entity.dart';
import '../../core/theme/app_theme.dart';

class CommerceCard extends StatelessWidget {
  final CommerceEntity commerce;
  const CommerceCard({super.key, required this.commerce});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.outlineVariant.withValues(alpha: 0.3)),
        boxShadow: [BoxShadow(color: AppTheme.primary.withValues(alpha: 0.05), blurRadius: 12, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: commerce.photos.isNotEmpty
                ? Image.network(commerce.photos.first, height: 160, width: double.infinity, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _iconBanner())
                : _iconBanner(),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(commerce.nom,
                        style: const TextStyle(fontFamily: 'Hanken Grotesk', fontSize: 17, fontWeight: FontWeight.w600, color: AppTheme.primary),
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                    ),
                    Row(children: [
                      const Icon(Icons.star_rounded, color: AppTheme.savannahGold, size: 16),
                      const SizedBox(width: 2),
                      Text(commerce.noteMoyenne.toStringAsFixed(1),
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                    ]),
                  ],
                ),
                const SizedBox(height: 4),
                Text(commerce.categorie,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.terracottaClay, letterSpacing: 0.3)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(children: [
                        const Icon(Icons.location_on_outlined, size: 13, color: AppTheme.onSurfaceVariant),
                        const SizedBox(width: 4),
                        Expanded(child: Text(
                          commerce.descriptionAdresse ?? 'Localisation',
                          style: const TextStyle(fontSize: 12, color: AppTheme.onSurfaceVariant),
                          overflow: TextOverflow.ellipsis,
                        )),
                      ]),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: commerce.estPublie
                            ? AppTheme.primaryContainer.withValues(alpha: 0.15)
                            : AppTheme.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        commerce.estPublie ? 'Publié' : 'Brouillon',
                        style: TextStyle(
                          fontSize: 11, fontWeight: FontWeight.w600,
                          color: commerce.estPublie ? AppTheme.primaryContainer : AppTheme.onSurfaceVariant,
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

  Widget _iconBanner() {
    return Container(
      height: 160, width: double.infinity,
      color: AppTheme.surfaceContainerHighest,
      child: Center(child: Icon(_getIcon(commerce.categorie), size: 52, color: AppTheme.outlineVariant)),
    );
  }

  IconData _getIcon(String cat) {
    switch (cat.toLowerCase()) {
      case 'mécanicien': return Icons.build_rounded;
      case 'couturier': return Icons.checkroom_rounded;
      case 'coiffeur': return Icons.content_cut_rounded;
      case 'soudeur': return Icons.hardware_rounded;
      case 'électricien': return Icons.electrical_services_rounded;
      default: return Icons.storefront_rounded;
    }
  }
}
