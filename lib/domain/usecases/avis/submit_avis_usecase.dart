import '../../repositories/i_avis_repository.dart';

class SubmitAvisUsecase {
  final IAvisRepository repo;

  SubmitAvisUsecase(this.repo);

  Future call({
    required String commerceId,
    required String commentaire,
  }) {
    return repo.submitAvis(commerceId: commerceId, commentaire: commentaire);
  }
}

