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

  Future<void> register({
    required String nom,
    required String email,
    required String telephone,
    required String password,
  }) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
      data: {'nom': nom, 'telephone': telephone},
    );
    if (response.user == null) throw Exception('Inscription échouée');
    // Le profil sera créé au premier login après confirmation email
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
    await _client.from('profile').update({
      'role_actif': role,
      'onboarding_fait': true,
    }).eq('id', userId);
  }

  Future<UserDto> _getProfile(String userId, String email) async {
    // Vérifie si le profil existe, sinon le crée avec les metadata
    final existing = await _client
        .from('profile')
        .select()
        .eq('id', userId)
        .maybeSingle();

    if (existing != null) {
      return UserDto.fromJson({...existing, 'email': email});
    }

    // Premier login après confirmation email : créer le profil
    final user = _client.auth.currentUser;
    final meta = user?.userMetadata ?? {};
    await _client.from('profile').insert({
      'id': userId,
      'nom': meta['nom'] ?? '',
      'email': email,
      'telephone': meta['telephone'] ?? '',
      'role_actif': 'citoyen',
      'onboarding_fait': false,
    });
    final data = await _client
        .from('profile')
        .select()
        .eq('id', userId)
        .single();
    return UserDto.fromJson({...data, 'email': email});
  }
}