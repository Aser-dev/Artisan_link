import '../../repositories/i_commerce_repository.dart';

class TogglePublicationUsecase {
  final ICommerceRepository repo;

  TogglePublicationUsecase(this.repo);

  Future<void> call({required String commerceId, required bool publish}) {
    return repo.togglePublication(id: commerceId, publish: publish);
  }
}
