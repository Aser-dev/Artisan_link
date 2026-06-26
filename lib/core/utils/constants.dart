// Ce fichier centralise les constantes de l’application.
// Il est utilisé par plusieurs couches (core / data / presentation).

class AppConstants {
  // Supabase configuration (placeholders)
  static const String supabaseUrl = 'https://YOUR_PROJECT.supabase.co';
  static const String supabaseAnonKey = 'YOUR_ANON_KEY';

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

