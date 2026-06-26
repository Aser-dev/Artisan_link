import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../datasources/remote/supabase_auth_datasource.dart';
import '../models/user_dto.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final SupabaseAuthDatasource ds;

  AuthRepositoryImpl(this.ds);

  @override
  Future<UserEntity> login({required String email, required String password}) async {
    final user = await ds.login(email: email, password: password);
    return UserDto.fromSupabase(
      id: user.id,
      email: user.email,
      data: user.userMetadata,
    ).toEntity();
  }

  @override
  Future<UserEntity> register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    final user = await ds.register(
      name: name,
      email: email,
      password: password,
      role: role,
    );

    return UserDto.fromSupabase(
      id: user.id,
      email: user.email,
      data: user.userMetadata,
    ).toEntity();
  }

  @override
  Future<void> signOut() => ds.signOut();

  @override
  Future<User?> getCurrentSupabaseUser() => ds.getCurrentUser();
}

