// Ce fichier contient la configuration DI (injection de dépendances).
// Objectif: câbler les providers Riverpod vers les implémentations Data.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers.dart';

import '../../data/datasources/remote/supabase_auth_datasource.dart';
import '../../data/datasources/remote/supabase_commerce_datasource.dart';
import '../../data/datasources/remote/supabase_avis_datasource.dart';
import '../../data/datasources/local/shared_prefs_datasource.dart';

import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/commerce_repository_impl.dart';
import '../../data/repositories/avis_repository_impl.dart';

import '../../domain/repositories/i_auth_repository.dart';
import '../../domain/repositories/i_commerce_repository.dart';
import '../../domain/repositories/i_avis_repository.dart';

import '../../domain/usecases/auth/login_usecase.dart';
import '../../domain/usecases/auth/register_usecase.dart';

/// IMPORTANT: `supabaseClientProvider` est défini dans `lib/core/di/providers.dart`.
/// On l’importe via `import 'providers.dart';` ci-dessus.

/// Repository (Auth)
final iAuthRepositoryProvider = Provider<IAuthRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  final ds = SupabaseAuthDatasource(supabase);
  return AuthRepositoryImpl(ds);
});

/// Repository (Commerce)
final iCommerceRepositoryProvider = Provider<ICommerceRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  final ds = SupabaseCommerceDatasource(supabase);
  return CommerceRepositoryImpl(ds);
});

/// Repository (Avis)
final iAvisRepositoryProvider = Provider<IAvisRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  final ds = SupabaseAvisDatasource(supabase);
  return AvisRepositoryImpl(ds);
});

/// Use cases (Auth)
final loginUsecaseProvider = Provider<LoginUsecase>((ref) {
  final repo = ref.watch(iAuthRepositoryProvider);
  return LoginUsecase(repo);
});

final registerUsecaseProvider = Provider<RegisterUsecase>((ref) {
  final repo = ref.watch(iAuthRepositoryProvider);
  return RegisterUsecase(repo);
});

/// Placeholder pour shared prefs datasource (initialisation à câbler)
final sharedPrefsDatasourceProvider = Provider<SharedPrefsDatasource>((ref) {
  throw UnimplementedError(
    'SharedPrefsDatasourceProvider n’est pas encore câblé (initialisation SharedPreferences manquante)',
  );
});
