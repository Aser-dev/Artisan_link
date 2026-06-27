// lib/data/repositories/auth_repository_impl.dart
import 'dart:math';

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../datasources/remote/supabase_auth_datasource.dart';
import '../datasources/local/shared_prefs_datasource.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final SupabaseAuthDatasource _remote;
  final SharedPrefsDatasource _local;

  AuthRepositoryImpl(this._remote, this._local);

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    final dto = await _remote.login(email: email, password: password);
    await _local.saveRole(dto.roleActif);
    if (dto.onboardingFait) await _local.setOnboardingFait();
    return dto.toEntity();
  }

  @override
  Future<UserEntity> register({
    required String nom,
    required String email,
    required String telephone,
    required String password,
  }) async {
    final dto = await _remote.register(
      nom: nom,
      email: email,
      telephone: telephone,
      password: password,
    );
    return dto.toEntity();
  }

  @override
  Future<void> resetPassword({required String email}) {
    return _remote.resetPassword(email: email);
  }

  @override
  Future<void> logout() async {
    await _remote.logout();
    await _local.clear();
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final dto = await _remote.getCurrentUser();
    return dto?.toEntity();
  }

  @override
  Future<void> setRole({required String userId, required String role}) async {
    await Future.wait([
      _remote.setRole(userId: userId, role: role),
      _local.saveRole(role),
      _local.setOnboardingFait(),
    ]);
  }
}
