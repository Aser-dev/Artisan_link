// lib/data/repositories/auth_repository_impl.dart
import 'dart:math';

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../datasources/remote/supabase_auth_datasource.dart';
import '../datasources/local/shared_prefs_datasource.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final SupabaseAuthDatasource _remote;
  final SharedPrefsDatasource _local;

  AuthRepositoryImpl(this._remote, this._local);

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    // TODO(Mock temporaire) : garder la structure, mais commenter l'appel Supabase.
    // final dto = await _remote.login(email: email, password: password);
    // await _local.saveRole(dto.roleActif);
    // if (dto.onboardingFait) await _local.setOnboardingFait();
    // return dto.toEntity();

    // Validation mock : email/mot de passe non vides
    if (email.trim().isEmpty || password.trim().isEmpty) {
      throw Exception('Email et mot de passe doivent être non vides');
    }

    // Temps d'attente simulé (effet réseau)
    await Future.delayed(const Duration(seconds: 1));

    // Rôle mock :
    // - Si email contient "artisan" => artisan
    // - Sinon => citoyen
    final lowerEmail = email.trim().toLowerCase();
    final roleActif = lowerEmail.contains('artisan') ? 'artisan' : 'citoyen';

    // Onboarding mock :
    // - Si email contient "onboard" => onboarding fait
    // - Sinon => onboarding non fait
    final onboardingFait = lowerEmail.contains('onboard');

    final random = Random(email.hashCode);
    final id = 'mock_${random.nextInt(1 << 31)}';

    final user = UserEntity(
      id: id,
      nom: 'MockUser',
      email: email.trim(),
      telephone: '000000000',
      roleActif: roleActif,
      onboardingFait: onboardingFait,
    );

    // Conserver les interactions locales comme le ferait le vrai flow.
    // NOTE: on commente/ignore partiellement l'écriture si tu veux un rendu
    // 100% UI sans dépendre du stockage.
    await _local.saveRole(user.roleActif);
    // Dans le vrai code, setOnboardingFait() est appelé quand onboardingFait == true.
    if (user.onboardingFait) {
      await _local.setOnboardingFait();
    }

    return user;
  }

  @override
  Future<UserEntity> register({
    required String nom,
    required String email,
    required String telephone,
    required String password,
  }) async {
    // TODO(Mock temporaire) : garder la structure, mais commenter l'appel Supabase.
    // final dto = await _remote.register(
    //   nom: nom,
    //   email: email,
    //   telephone: telephone,
    //   password: password,
    // );
    // return dto.toEntity();

    // Validation mock : toutes les données non vides
    if (nom.trim().isEmpty ||
        email.trim().isEmpty ||
        telephone.trim().isEmpty ||
        password.trim().isEmpty) {
      throw Exception('Toutes les informations doivent être non vides');
    }

    // Temps d'attente simulé (effet réseau)
    await Future.delayed(const Duration(seconds: 1));

    // Inscription mock : onboardingFait = false
    final lowerEmail = email.trim().toLowerCase();
    final roleActif = lowerEmail.contains('artisan') ? 'artisan' : 'citoyen';

    final random = Random(email.hashCode + nom.hashCode);
    final id = 'mock_${random.nextInt(1 << 31)}';

    final user = UserEntity(
      id: id,
      nom: nom.trim(),
      email: email.trim(),
      telephone: telephone.trim(),
      roleActif: roleActif,
      onboardingFait: false,
    );

    // Conserver la logique locale attendue
    await _local.saveRole(user.roleActif);
    // onboardingFait=false => pas de setOnboardingFait()

    return user;
  }

  @override
  Future<void> resetPassword({required String email}) {
    // TODO(Mock temporaire) : on garde l'implémentation existante.
    return _remote.resetPassword(email: email);
  }

  @override
  Future<void> logout() async {
    await _remote.logout();
    await _local.clear();
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final dto = await _remote.getCurrentUser();
    return dto?.toEntity();
  }

  @override
  Future<void> setRole({required String userId, required String role}) async {
    await Future.wait([
      _remote.setRole(userId: userId, role: role),
      _local.saveRole(role),
      _local.setOnboardingFait(),
    ]);
  }
}
