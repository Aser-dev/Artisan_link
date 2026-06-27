// lib/domain/entities/user_entity.dart
class UserEntity {
  final String id;
  final String email;
  final String roleActif;
  final bool onboardingFait;

  String get nom => email.split('@').first;

  const UserEntity({
    required this.id,
    required this.email,
    this.roleActif = 'citoyen',
    this.onboardingFait = false,
  });

  bool get estArtisan => roleActif == 'artisan';

  UserEntity copyWith({
    String? roleActif,
    bool? onboardingFait,
  }) {
    return UserEntity(
      id: id,
      email: email,
      roleActif: roleActif ?? this.roleActif,
      onboardingFait: onboardingFait ?? this.onboardingFait,
    );
  }
}
