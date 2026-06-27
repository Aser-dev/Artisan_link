// lib/data/models/user_dto.dart
import '../../domain/entities/user_entity.dart';

class UserDto {
  final String id;
  final String nom;
  final String email;
  final String? telephone;
  final String roleActif;
  final bool onboardingFait;

  const UserDto({
    required this.id,
    required this.nom,
    required this.email,
    this.telephone,
    required this.roleActif,
    required this.onboardingFait,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: json['id'] as String,
      nom: json['nom'] as String,
      email: json['email'] as String,
      telephone: json['telephone'] as String?,
      roleActif: json['role_actif'] as String? ?? 'citoyen',
      onboardingFait: json['onboarding_fait'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'nom': nom,
    'email': email,
    'telephone': telephone,
    'role_actif': roleActif,
    'onboarding_fait': onboardingFait,
  };

  UserEntity toEntity() => UserEntity(
    id: id,
    nom: nom,
    email: email,
    telephone: telephone,
    roleActif: roleActif,
    onboardingFait: onboardingFait,
  );

  factory UserDto.fromEntity(UserEntity entity) => UserDto(
    id: entity.id,
    nom: entity.nom,
    email: entity.email,
    telephone: entity.telephone,
    roleActif: entity.roleActif,
    onboardingFait: entity.onboardingFait,
  );
}
