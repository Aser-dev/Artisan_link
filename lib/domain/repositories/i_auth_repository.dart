// lib/domain/repositories/i_auth_repository.dart
import '../entities/user_entity.dart';

abstract class IAuthRepository {
  Future<UserEntity> login({required String email, required String password});

  Future<UserEntity> register({
    required String nom,
    required String email,
    required String telephone,
    required String password,
  });

  Future<void> resetPassword({required String email});
  Future<void> logout();
  Future<UserEntity?> getCurrentUser();
  Future<void> setRole({required String userId, required String role});
}
