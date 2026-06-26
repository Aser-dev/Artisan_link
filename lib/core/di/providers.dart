// Ce fichier centralise les providers Riverpod (ex: Supabase client).

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../network/supabase_client.dart';

/// Provider du client Supabase utilisé dans toute l’application.
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return SupabaseClientFactory().create();
});

