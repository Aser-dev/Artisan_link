// lib/core/network/supabase_client.dart
import 'package:supabase_flutter/supabase_flutter.dart';

// NOTE: wrapper conservé uniquement si besoin.
// Le projet utilise Supabase.instance.client directement via providers.
class SupabaseClientWrapper {
  late final SupabaseClient client;

  Future<void> init({required String url, required String anonKey}) async {
    await Supabase.initialize(url: url, anonKey: anonKey);
    client = Supabase.instance.client;
  }

  SupabaseClient get() => client;
}
