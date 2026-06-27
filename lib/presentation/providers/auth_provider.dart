// lib/presentation/providers/auth_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/user_entity.dart';
import '../../core/di/injection_container.dart';

class AuthState {
  final UserEntity? user;
  final bool isLoading;
  final String? erreur;
  final bool emailConfirmationSent;

  const AuthState({this.user, this.isLoading = false, this.erreur, this.emailConfirmationSent = false});

  AuthState copyWith({
    UserEntity? user,
    bool? isLoading,
    String? erreur,
    bool? emailConfirmationSent,
    bool clearErreur = false,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      erreur: clearErreur ? null : erreur ?? this.erreur,
      emailConfirmationSent: emailConfirmationSent ?? this.emailConfirmationSent,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final Ref _ref;
  AuthNotifier(this._ref) : super(const AuthState()) {
    _init();
    // Écoute les changements de session (confirmation email, etc.)
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.signedIn && state.user == null) {
        _init();
      }
    });
  }

  Future<void> _init() async {
    state = state.copyWith(isLoading: true);
    try {
      final user = await _ref.read(authRepositoryProvider).getCurrentUser();
      state = state.copyWith(user: user, isLoading: false);
    } catch (_) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, clearErreur: true);
    try {
      final user = await _ref
          .read(loginUsecaseProvider)
          .call(email: email, password: password);
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, erreur: e.toString());
    }
  }

  Future<void> register({
    required String nom,
    required String email,
    required String telephone,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, clearErreur: true);
    try {
      await _ref
          .read(registerUsecaseProvider)
          .call(
            nom: nom,
            email: email,
            telephone: telephone,
            password: password,
          );
      state = state.copyWith(isLoading: false, emailConfirmationSent: true);
    } catch (e) {
      state = state.copyWith(isLoading: false, erreur: e.toString());
    }
  }

  Future<bool> resetPassword({required String email}) async {
    state = state.copyWith(isLoading: true, clearErreur: true);
    try {
      await _ref.read(resetPasswordUsecaseProvider).call(email: email);
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, erreur: e.toString());
      return false;
    }
  }

  Future<void> setRole({required String role}) async {
    if (state.user == null) return;
    state = state.copyWith(isLoading: true);
    try {
      await _ref
          .read(setRoleUsecaseProvider)
          .call(userId: state.user!.id, role: role);
      state = state.copyWith(
        user: state.user!.copyWith(roleActif: role, onboardingFait: true),
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, erreur: e.toString());
    }
  }

  Future<void> logout() async {
    await _ref.read(authRepositoryProvider).logout();
    state = const AuthState();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
});

// Alias pour compatibilité
final authNotifierProvider = authProvider;

final currentUserProvider = Provider<UserEntity?>((ref) {
  return ref.watch(authProvider).user;
});
