// lib/domain/usecases/auth/login_usecase.dart
import '../../entities/user_entity.dart';
import '../../repositories/i_auth_repository.dart';

class LoginUsecase {
  final IAuthRepository repository;
  const LoginUsecase(this.repository);

  Future<UserEntity> call({required String email, required String password}) {
    return repository.login(email: email, password: password);
  }
}
