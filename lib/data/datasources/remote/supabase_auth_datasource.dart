import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthDatasource {
  final SupabaseClient client;

  SupabaseAuthDatasource(this.client);

  Future<User> login({required String email, required String password}) async {
    final res = await client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    final user = res.user;
    if (user == null) {
      throw StateError('Login failed: user is null');
    }
    return user;
  }

  Future<User> register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    final res = await client.auth.signUp(
      email: email,
      password: password,
      data: {'name': name, 'role': role},
    );

    final user = res.user;
    if (user == null) {
      throw StateError('Register failed: user is null');
    }
    return user;
  }

  Future<void> signOut() => client.auth.signOut();

  Future<User?> getCurrentUser() async => client.auth.currentUser;
}
