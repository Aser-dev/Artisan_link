// lib/data/datasources/remote/supabase_auth_datasource.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/user_dto.dart';

class SupabaseAuthDatasource {
  final SupabaseClient _client;
  SupabaseAuthDatasource(this._client);

  Future<UserDto> login({required String email, required String password}) async {
    final response = await _client.auth.signInWithPassword(email: email, password: password);
    if (response.user == null) throw Exception('Connexion échouée');
    return UserDto.fromSupabase(response.user!);
  }

  Future<UserDto> register({required String email, required String password}) async {
    final response = await _client.auth.signUp(email: email, password: password);
    if (response.user == null) throw Exception('Inscription échouée');
    return UserDto.fromSupabase(response.user!);
  }

  Future<void> resetPassword({required String email}) async {
    await _client.auth.resetPasswordForEmail(
      email,
      redirectTo: 'artisanbf://reset-password',
    );
  }

  Future<void> logout() async {
    await _client.auth.signOut();
  }

  Future<UserDto?> getCurrentUser() async {
    final user = _client.auth.currentUser;
    if (user == null) return null;
    return UserDto.fromSupabase(user);
  }

  Future<void> setRole({required String userId, required String role}) async {}
}
