import '../../repositories/i_auth_repository.dart';

class RegisterUsecase {
  final IAuthRepository repo;

  RegisterUsecase(this.repo);

  Future register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) {
    return repo.register(
      name: name,
      email: email,
      password: password,
      role: role,
    );
  }
}
