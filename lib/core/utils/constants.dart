// Ce fichier centralise les constantes de l’application.

import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  // Supabase configuration (from .env)
  static String get supabaseUrl =>
      dotenv.env['SUPABASE_URL'] ?? 'https://skebhzipxbzstmzqchhd.supabase.co';
  static String get supabaseAnonKey =>
      dotenv.env['SUPABASE_ANON_KEY'] ??
      'sb_publishable_C7sIHh2OpoW-WNkQiytPRw_YM5ojUQw';

  // Local storage keys
  static const String prefRoleActifKey = 'role_actif';
  static const String prefOnboardingFaitKey = 'onboarding_fait';

  // Liste complète des catégories demandées
  static const List<String> categories = <String>[
    'mécanicien',
    'couturier',
    'coiffeur',
    'soudeur',
    'électricien',
    'plombier',
    'menuisier',
    'réparateur téléphone',
  ];
}
