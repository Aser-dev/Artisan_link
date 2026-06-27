// lib/domain/entities/user_entity.dart
class UserEntity {
  final String id;
  final String nom;
  final String email;
  final String? telephone;
  final String roleActif;
  final bool onboardingFait;

  const UserEntity({
    required this.id,
    required this.nom,
    required this.email,
    this.telephone,
    required this.roleActif,
    required this.onboardingFait,
  });

  bool get estArtisan => roleActif == 'artisan';

  UserEntity copyWith({
    String? nom,
    String? telephone,
    String? roleActif,
    bool? onboardingFait,
  }) {
    return UserEntity(
      id: id,
      nom: nom ?? this.nom,
      email: email,
      telephone: telephone ?? this.telephone,
      roleActif: roleActif ?? this.roleActif,
      onboardingFait: onboardingFait ?? this.onboardingFait,
    );
  }
}
