// Ce provider gère la logique d'authentification via Riverpod StateNotifier.

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/di/injection_container.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../../domain/usecases/auth/login_usecase.dart';
import '../../domain/usecases/auth/register_usecase.dart';

/// État de l'authentification pour l'UI
class AuthUiState {
  final bool isLoading;
  final UserEntity? user;
  final String? error;
  final bool isAuthenticated;

  const AuthUiState({
    this.isLoading = false,
    this.user,
    this.error,
    this.isAuthenticated = false,
  });

  AuthUiState copyWith({
    bool? isLoading,
    UserEntity? user,
    String? error,
    bool? isAuthenticated,
  }) {
    return AuthUiState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }

  AuthUiState clearError() => copyWith(error: null);
}

class AuthNotifier extends StateNotifier<AuthUiState> {
  final LoginUsecase loginUsecase;
  final RegisterUsecase registerUsecase;
  final IAuthRepository repo;
  StreamSubscription<AuthState>? _authSubscription;

  AuthNotifier({
    required this.loginUsecase,
    required this.registerUsecase,
    required this.repo,
  }) : super(const AuthUiState()) {
    _listenToAuthChanges();
  }

  void _listenToAuthChanges() {
    _authSubscription = Supabase.instance.client.auth.onAuthStateChange.listen((
      event,
    ) async {
      if (event.session?.user != null) {
        final supabaseUser = event.session!.user;
        final user = UserEntity(
          id: supabaseUser.id,
          name: supabaseUser.userMetadata?['name']?.toString() ?? '',
          email: supabaseUser.email ?? '',
          role: supabaseUser.userMetadata?['role']?.toString() ?? '',
        );
        state = state.copyWith(
          user: user,
          isAuthenticated: true,
          isLoading: false,
          error: null,
        );
      } else {
        state = const AuthUiState();
      }
    });
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await loginUsecase.login(email: email, password: password);
      // L'état sera mis à jour via onAuthStateChange
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await registerUsecase.register(
        name: name,
        email: email,
        password: password,
        role: role,
      );
      // L'état sera mis à jour via onAuthStateChange
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> signOut() async {
    await repo.signOut();
    state = const AuthUiState();
  }

  Future<void> resetPassword(String email) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await Supabase.instance.client.auth.resetPasswordForEmail(email);
      state = state.copyWith(isLoading: false, error: null);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void clearError() => state = state.clearError();

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthUiState>((
  ref,
) {
  final repo = ref.watch(iAuthRepositoryProvider);
  final loginUsecase = ref.watch(loginUsecaseProvider);
  final registerUsecase = ref.watch(registerUsecaseProvider);

  return AuthNotifier(
    loginUsecase: loginUsecase,
    registerUsecase: registerUsecase,
    repo: repo,
  );
});
