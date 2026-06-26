// Ce provider gère la logique d’authentification via Riverpod.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/usecases/auth/login_usecase.dart';
import '../../domain/usecases/auth/register_usecase.dart';
import '../../domain/repositories/i_auth_repository.dart';

import '../../core/di/injection_container.dart';

/// Contrôleur (ViewModel) minimal.
class AuthController {
  final LoginUsecase loginUsecase;
  final RegisterUsecase registerUsecase;
  final IAuthRepository repo;

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

final authControllerProvider = Provider<AuthController>((ref) {
  final repo = ref.watch(iAuthRepositoryProvider);
  final loginUsecase = ref.watch(loginUsecaseProvider);
  final registerUsecase = ref.watch(registerUsecaseProvider);

  return AuthController(
    loginUsecase: loginUsecase,
    registerUsecase: registerUsecase,
    repo: repo,
  );
});
