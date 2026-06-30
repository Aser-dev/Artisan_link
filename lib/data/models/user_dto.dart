// lib/data/models/user_dto.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/user_entity.dart';

class UserDto {
  final String id;
  final String email;
  final String roleActif;
  final bool onboardingFait;

  const UserDto({
    required this.id,
    required this.email,
    this.roleActif = 'citoyen',
    this.onboardingFait = false,
  });

  factory UserDto.fromSupabase(User user) {
    return UserDto(
      id: user.id,
      email: user.email ?? '',
      roleActif: user.userMetadata?['role_actif'] as String? ?? 'citoyen',
      onboardingFait: user.userMetadata?['onboarding_fait'] as bool? ?? false,
    );
  }

  UserEntity toEntity() => UserEntity(
    id: id,
    email: email,
    roleActif: roleActif,
    onboardingFait: onboardingFait,
  );
}
