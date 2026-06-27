class CommerceEntity {
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

  const CommerceEntity({
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

  CommerceEntity copyWith({
    String? id,
    String? userId,
    String? nom,
    String? categorie,
    String? telephone,
    String? descriptionAdresse,
    double? latitude,
    double? longitude,
    String? horaires,
    List<String>? photos,
    bool? estPublie,
    double? noteMoyenne,
    int? nombreAvis,
    DateTime? createdAt,
  }) {
    return CommerceEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      nom: nom ?? this.nom,
      categorie: categorie ?? this.categorie,
      telephone: telephone ?? this.telephone,
      descriptionAdresse: descriptionAdresse ?? this.descriptionAdresse,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      horaires: horaires ?? this.horaires,
      photos: photos ?? this.photos,
      estPublie: estPublie ?? this.estPublie,
      noteMoyenne: noteMoyenne ?? this.noteMoyenne,
      nombreAvis: nombreAvis ?? this.nombreAvis,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  bool get aPosition => latitude != null && longitude != null;
}
