// lib/domain/usecases/commerce/toggle_publication_usecase.dart
import '../../repositories/i_commerce_repository.dart';

class TogglePublicationUsecase {
  final ICommerceRepository repository;
  const TogglePublicationUsecase(this.repository);

  Future<void> call({required String commerceId, required bool publier}) {
    return repository.togglePublication(
      commerceId: commerceId,
      publier: publier,
    );
  }
}
