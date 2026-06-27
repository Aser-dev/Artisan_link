// lib/domain/usecases/auth/set_role_usecase.dart
import '../../repositories/i_auth_repository.dart';

class SetRoleUsecase {
  final IAuthRepository repository;
  const SetRoleUsecase(this.repository);

  Future<void> call({required String userId, required String role}) {
    return repository.setRole(userId: userId, role: role);
  }
}
