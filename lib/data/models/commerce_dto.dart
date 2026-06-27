// lib/data/models/commerce_dto.dart
import '../../domain/entities/commerce_entity.dart';

class CommerceDto {
  final String id;
  final String userId;
  final String nom;
  final String categorie;
  final String? telephone;
  final String? descriptionAdresse;
  final double? latitude;
  final double? longitude;
  final String? horaires;
  final List<String> photos;
  final bool estPublie;
  final double noteMoyenne;
  final int nombreAvis;
  final DateTime createdAt;

  const CommerceDto({
    required this.id,
    required this.userId,
    required this.nom,
    required this.categorie,
    this.telephone,
    this.descriptionAdresse,
    this.latitude,
    this.longitude,
    this.horaires,
    required this.photos,
    required this.estPublie,
    required this.noteMoyenne,
    required this.nombreAvis,
    required this.createdAt,
  });

  factory CommerceDto.fromJson(Map<String, dynamic> json) => CommerceDto(
    id: json['id'] as String,
    userId: json['user_id'] as String,
    nom: json['nom'] as String,
    categorie: json['categorie'] as String,
    telephone: json['telephone'] as String?,
    descriptionAdresse: json['description_adresse'] as String?,
    latitude: (json['latitude'] as num?)?.toDouble(),
    longitude: (json['longitude'] as num?)?.toDouble(),
    horaires: json['horaires'] as String?,
    photos: (json['photos'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
    estPublie: json['est_publie'] as bool? ?? false,
    noteMoyenne: (json['note_moyenne'] as num?)?.toDouble() ?? 0.0,
    nombreAvis: json['nombre_avis'] as int? ?? 0,
    createdAt: DateTime.parse(json['created_at'] as String),
  );

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'nom': nom,
    'categorie': categorie,
    'telephone': telephone,
    'description_adresse': descriptionAdresse,
    'latitude': latitude,
    'longitude': longitude,
    'horaires': horaires,
    'photos': photos,
    'est_publie': estPublie,
  };

  CommerceEntity toEntity() => CommerceEntity(
    id: id,
    userId: userId,
    nom: nom,
    categorie: categorie,
    telephone: telephone,
    descriptionAdresse: descriptionAdresse,
    latitude: latitude,
    longitude: longitude,
    horaires: horaires,
    photos: photos,
    estPublie: estPublie,
    noteMoyenne: noteMoyenne,
    nombreAvis: nombreAvis,
    createdAt: createdAt,
  );

  factory CommerceDto.fromEntity(CommerceEntity entity) => CommerceDto(
    id: entity.id,
    userId: entity.userId,
    nom: entity.nom,
    categorie: entity.categorie,
    telephone: entity.telephone,
    descriptionAdresse: entity.descriptionAdresse,
    latitude: entity.latitude,
    longitude: entity.longitude,
    horaires: entity.horaires,
    photos: entity.photos,
    estPublie: entity.estPublie,
    noteMoyenne: entity.noteMoyenne,
    nombreAvis: entity.nombreAvis,
    createdAt: entity.createdAt,
  );
}