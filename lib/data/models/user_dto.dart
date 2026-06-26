import '../../domain/entities/user_entity.dart';

class UserDto {
  final String id;
  final String name;
  final String email;
  final String role;

  const UserDto({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });


  factory UserDto.fromSupabase({
    required String id,
    required String? email,
    required Map<String, dynamic>? data,
  }) {
    return UserDto(
      id: id,
      email: email ?? '',
      name: (data?['name'] ?? '').toString(),
      role: (data?['role'] ?? '').toString(),
    );
  }

  UserEntity toEntity() => UserEntity(
        id: id,
        name: name,
        email: email,
        role: role,
      );
}

