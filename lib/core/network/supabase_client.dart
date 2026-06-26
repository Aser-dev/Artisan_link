// Ce fichier fabrique le client Supabase unique utilisé dans l’application.

import 'package:supabase_flutter/supabase_flutter.dart';

import '../utils/constants.dart';

class SupabaseClientFactory {
  SupabaseClientFactory();

  SupabaseClient create() {
    return SupabaseClient(AppConstants.supabaseUrl, AppConstants.supabaseAnonKey);
  }
}

