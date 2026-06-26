import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../network/supabase_client.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  // Create one client instance per provider scope.
  return SupabaseClientFactory().create();
});

