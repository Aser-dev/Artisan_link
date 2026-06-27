// lib/domain/entities/avis_entity.dart
class AvisEntity {
  final String id;
  final String commerceId;
  final String auteurId;
  final String auteurNom;
  final String commentaire;
  final int noteIa;
  final String? raisonIa;
  final DateTime createdAt;

  const AvisEntity({
    required this.id,
    required this.commerceId,
    required this.auteurId,
    required this.auteurNom,
    required this.commentaire,
    required this.noteIa,
    this.raisonIa,
    required this.createdAt,
  });
}