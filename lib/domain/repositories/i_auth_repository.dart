import 'package:supabase_flutter/supabase_flutter.dart';

import '../entities/user_entity.dart';

abstract class IAuthRepository {
  Future<UserEntity> login({required String email, required String password});

  Future<UserEntity> register({
    required String name,
    required String email,
    required String password,
    required String role,
  });

  Future<void> signOut();

  Future<User?> getCurrentSupabaseUser();
}
