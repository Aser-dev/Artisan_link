// lib/presentation/widgets/commerce_card.dart
// Carte d'affichage d'un commerce au design sombre minimaliste
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/commerce_entity.dart';
import '../../core/theme/app_theme.dart';
import 'design_system.dart';

class CommerceCard extends StatelessWidget {
  final CommerceEntity commerce;

  const CommerceCard({super.key, required this.commerce});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.bordureSubtile),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image banner
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: commerce.photos.isNotEmpty
                ? Image.network(
                    commerce.photos.first,
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => _iconBanner(),
                  )
                : _iconBanner(),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        commerce.nom,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textePrimaire,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: Color(0xFF8CD82C),
                          size: 16,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          commerce.noteMoyenne.toStringAsFixed(1),
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: AppTheme.textePrimaire,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  commerce.categorie,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.accentPrimaire,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 13,
                            color: AppTheme.texteSecondaire,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              commerce.descriptionAdresse ?? 'Localisation',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppTheme.texteSecondaire,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    StatutBadge(
                      label: commerce.estPublie ? 'Publié' : 'Brouillon',
                      actif: commerce.estPublie,
                      couleurActive: AppTheme.accentPrimaire,
                      couleurInactive: AppTheme.texteTertiaire,
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
      height: 160,
      width: double.infinity,
      color: AppTheme.surfaceCardHover,
      child: Center(
        child: Icon(
          _getIcon(commerce.categorie),
          size: 52,
          color: AppTheme.texteTertiaire,
        ),
      ),
    );
  }

  IconData _getIcon(String cat) {
    switch (cat.toLowerCase()) {
      case 'mécanicien':
        return Icons.build_rounded;
      case 'couturier':
        return Icons.checkroom_rounded;
      case 'coiffeur':
        return Icons.content_cut_rounded;
      case 'soudeur':
        return Icons.hardware_rounded;
      case 'électricien':
        return Icons.electrical_services_rounded;
      default:
        return Icons.storefront_rounded;
    }
  }
}