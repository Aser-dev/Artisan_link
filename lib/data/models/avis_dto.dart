// lib/data/models/avis_dto.dart
import '../../domain/entities/avis_entity.dart';

class AvisDto {
  final String id;
  final String commerceId;
  final String auteurId;
  final String auteurNom;
  final String commentaire;
  final int noteIa;
  final String? raisonIa;
  final DateTime createdAt;

  const AvisDto({
    required this.id,
    required this.commerceId,
    required this.auteurId,
    required this.auteurNom,
    required this.commentaire,
    required this.noteIa,
    this.raisonIa,
    required this.createdAt,
  });

  factory AvisDto.fromJson(Map<String, dynamic> json) => AvisDto(
    id: json['id'] as String,
    commerceId: json['commerce_id'] as String,
    auteurId: json['auteur_id'] as String,
    auteurNom: json['auteur_nom'] as String? ?? 'Anonyme',
    commentaire: json['commentaire'] as String,
    noteIa: json['note_ia'] as int? ?? 3,
    raisonIa: json['raison_ia'] as String?,
    createdAt: DateTime.parse(json['created_at'] as String),
  );

  Map<String, dynamic> toJson() => {
    'commerce_id': commerceId,
    'auteur_id': auteurId,
    'auteur_nom': auteurNom,
    'commentaire': commentaire,
    'note_ia': noteIa,
    'raison_ia': raisonIa,
  };

  AvisEntity toEntity() => AvisEntity(
    id: id,
    commerceId: commerceId,
    auteurId: auteurId,
    auteurNom: auteurNom,
    commentaire: commentaire,
    noteIa: noteIa,
    raisonIa: raisonIa,
    createdAt: createdAt,
  );
}
