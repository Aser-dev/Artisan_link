import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/usecases/auth/login_usecase.dart';
import '../../domain/usecases/auth/register_usecase.dart';
import '../../data/datasources/remote/supabase_auth_datasource.dart';

import '../../core/di/injection_container.dart';
import '../../data/repositories/auth_repository_impl.dart';

final authControllerProvider = Provider<AuthController>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  final repo = AuthRepositoryImpl(SupabaseAuthDatasource(supabase));
  return AuthController(
    loginUsecase: LoginUsecase(repo),
    registerUsecase: RegisterUsecase(repo),
    repo: repo,
  );
});

class AuthController {
  final LoginUsecase loginUsecase;
  final RegisterUsecase registerUsecase;
  final AuthRepositoryImpl repo;

  AuthController({
    required this.loginUsecase,
    required this.registerUsecase,
    required this.repo,
  });

  Future<void> login(String email, String password) async {
    await loginUsecase.login(email: email, password: password);
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    await registerUsecase.register(
      name: name,
      email: email,
      password: password,
      role: role,
    );
  }

  Future<void> signOut() => repo.signOut();

  Future<User?> getCurrentUser() => repo.getCurrentSupabaseUser();
}
