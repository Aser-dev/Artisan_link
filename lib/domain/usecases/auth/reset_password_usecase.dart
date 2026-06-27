// lib/domain/usecases/auth/reset_password_usecase.dart
import '../../repositories/i_auth_repository.dart';

class ResetPasswordUsecase {
  final IAuthRepository repository;
  const ResetPasswordUsecase(this.repository);

  Future<void> call({required String email}) {
    return repository.resetPassword(email: email);
  }
}
