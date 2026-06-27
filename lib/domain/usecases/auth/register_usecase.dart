// lib/domain/usecases/auth/register_usecase.dart
import '../../repositories/i_auth_repository.dart';

class RegisterUsecase {
  final IAuthRepository repository;
  const RegisterUsecase(this.repository);

  Future<void> call({
    required String nom,
    required String email,
    required String telephone,
    required String password,
  }) {
    return repository.register(
      nom: nom,
      email: email,
      telephone: telephone,
      password: password,
    );
  }
}
