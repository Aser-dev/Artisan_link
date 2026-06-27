// lib/data/repositories/auth_repository_impl.dart
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../datasources/remote/supabase_auth_datasource.dart';
import '../datasources/local/shared_prefs_datasource.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final SupabaseAuthDatasource _remote;
  final SharedPrefsDatasource _local;

  AuthRepositoryImpl(this._remote, this._local);

  @override
  Future<UserEntity> login({required String email, required String password}) async {
    final dto = await _remote.login(email: email, password: password);
    return dto.toEntity();
  }

  @override
  Future<UserEntity> register({required String email, required String password}) async {
    final dto = await _remote.register(email: email, password: password);
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
    await _local.saveRole(role);
  }
}
