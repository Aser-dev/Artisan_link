import '../../repositories/i_auth_repository.dart';

class LoginUsecase {
  final IAuthRepository repo;

  LoginUsecase(this.repo);

  Future login({required String email, required String password}) {
    return repo.login(email: email, password: password);
  }
}

