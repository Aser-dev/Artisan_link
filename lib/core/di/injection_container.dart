// lib/core/di/injection_container.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// --- Datasources ---
import '../../data/datasources/remote/supabase_auth_datasource.dart';
import '../../data/datasources/remote/supabase_commerce_datasource.dart';
import '../../data/datasources/remote/supabase_avis_datasource.dart';
import '../../data/datasources/local/shared_prefs_datasource.dart';

// --- Repositories ---
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/commerce_repository_impl.dart';
import '../../data/repositories/avis_repository_impl.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../../domain/repositories/i_commerce_repository.dart';
import '../../domain/repositories/i_avis_repository.dart';

// --- Usecases ---
import '../../domain/usecases/auth/login_usecase.dart';
import '../../domain/usecases/auth/register_usecase.dart';
import '../../domain/usecases/auth/reset_password_usecase.dart';
import '../../domain/usecases/auth/set_role_usecase.dart';
import '../../domain/usecases/commerce/get_nearby_commerces_usecase.dart';
import '../../domain/usecases/commerce/create_commerce_usecase.dart';
import '../../domain/usecases/commerce/update_commerce_usecase.dart';
import '../../domain/usecases/commerce/toggle_publication_usecase.dart';
import '../../domain/usecases/avis/submit_avis_usecase.dart';
import '../../domain/usecases/avis/get_avis_commerce_usecase.dart';

// ── Client Supabase ──────────────────────
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// ── Datasources ──────────────────────────
final sharedPrefsDatasourceProvider = Provider<SharedPrefsDatasource>((ref) {
  return SharedPrefsDatasource();
});

final supabaseAuthDatasourceProvider = Provider<SupabaseAuthDatasource>((ref) {
  return SupabaseAuthDatasource(ref.read(supabaseClientProvider));
});

final supabaseCommerceDatasourceProvider = Provider<SupabaseCommerceDatasource>((ref) {
  return SupabaseCommerceDatasource(ref.read(supabaseClientProvider));
});

final supabaseAvisDatasourceProvider = Provider<SupabaseAvisDatasource>((ref) {
  return SupabaseAvisDatasource(ref.read(supabaseClientProvider));
});

// ── Repositories ─────────────────────────
final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  return AuthRepositoryImpl(
    ref.read(supabaseAuthDatasourceProvider),
    ref.read(sharedPrefsDatasourceProvider),
  );
});

final commerceRepositoryProvider = Provider<ICommerceRepository>((ref) {
  return CommerceRepositoryImpl(ref.read(supabaseCommerceDatasourceProvider));
});

final avisRepositoryProvider = Provider<IAvisRepository>((ref) {
  return AvisRepositoryImpl(ref.read(supabaseAvisDatasourceProvider));
});

// ── Usecases Auth ────────────────────────
final loginUsecaseProvider = Provider<LoginUsecase>((ref) {
  return LoginUsecase(ref.read(authRepositoryProvider));
});

final registerUsecaseProvider = Provider<RegisterUsecase>((ref) {
  return RegisterUsecase(ref.read(authRepositoryProvider));
});

final resetPasswordUsecaseProvider = Provider<ResetPasswordUsecase>((ref) {
  return ResetPasswordUsecase(ref.read(authRepositoryProvider));
});

final setRoleUsecaseProvider = Provider<SetRoleUsecase>((ref) {
  return SetRoleUsecase(ref.read(authRepositoryProvider));
});

// ── Usecases Commerce ────────────────────
final getNearbyCommercesUsecaseProvider = Provider<GetNearbyCommercesUsecase>((ref) {
  return GetNearbyCommercesUsecase(ref.read(commerceRepositoryProvider));
});

final createCommerceUsecaseProvider = Provider<CreateCommerceUsecase>((ref) {
  return CreateCommerceUsecase(ref.read(commerceRepositoryProvider));
});

final updateCommerceUsecaseProvider = Provider<UpdateCommerceUsecase>((ref) {
  return UpdateCommerceUsecase(ref.read(commerceRepositoryProvider));
});

final togglePublicationUsecaseProvider = Provider<TogglePublicationUsecase>((ref) {
  return TogglePublicationUsecase(ref.read(commerceRepositoryProvider));
});

// ── Usecases Avis ────────────────────────
final submitAvisUsecaseProvider = Provider<SubmitAvisUsecase>((ref) {
  return SubmitAvisUsecase(ref.read(avisRepositoryProvider));
});

final getAvisCommerceUsecaseProvider = Provider<GetAvisCommerceUsecase>((ref) {
  return GetAvisCommerceUsecase(ref.read(avisRepositoryProvider));
});