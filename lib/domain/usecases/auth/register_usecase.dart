// lib/domain/usecases/auth/register_usecase.dart
import '../../entities/user_entity.dart';
import '../../repositories/i_auth_repository.dart';

class RegisterUsecase {
  final IAuthRepository repository;
  const RegisterUsecase(this.repository);

  Future<UserEntity> call({required String email, required String password}) {
    return repository.register(email: email, password: password);
  }
}
