// lib/data/datasources/remote/supabase_auth_datasource.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/user_dto.dart';

class SupabaseAuthDatasource {
  final SupabaseClient _client;
  SupabaseAuthDatasource(this._client);

  Future<UserDto> login({required String email, required String password}) async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    if (response.user == null) throw Exception('Connexion échouée');
    return _getProfile(response.user!.id, response.user!.email!);
  }

  Future<UserDto> register({
    required String nom,
    required String email,
    required String telephone,
    required String password,
  }) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
    );
    if (response.user == null) throw Exception('Inscription échouée');
    await _client.from('profiles').insert({
      'id': response.user!.id,
      'nom': nom,
      'email': email,
      'telephone': telephone,
      'role_actif': 'citoyen',
      'onboarding_fait': false,
    });
    return UserDto(
      id: response.user!.id,
      nom: nom,
      email: email,
      telephone: telephone,
      roleActif: 'citoyen',
      onboardingFait: false,
    );
  }

  Future<void> resetPassword({required String email}) async {
    await _client.auth.resetPasswordForEmail(email);
  }

  Future<void> logout() async {
    await _client.auth.signOut();
  }

  Future<UserDto?> getCurrentUser() async {
    final user = _client.auth.currentUser;
    if (user == null) return null;
    return _getProfile(user.id, user.email!);
  }

  Future<void> setRole({required String userId, required String role}) async {
    await _client.from('profiles').update({
      'role_actif': role,
      'onboarding_fait': true,
    }).eq('id', userId);
  }

  Future<UserDto> _getProfile(String userId, String email) async {
    final data = await _client
        .from('profiles')
        .select()
        .eq('id', userId)
        .single();
    return UserDto.fromJson({...data, 'email': email});
  }
}