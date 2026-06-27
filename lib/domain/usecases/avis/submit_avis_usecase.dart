// lib/domain/usecases/avis/submit_avis_usecase.dart
import '../../entities/avis_entity.dart';
import '../../repositories/i_avis_repository.dart';

class SubmitAvisUsecase {
  final IAvisRepository repository;
  const SubmitAvisUsecase(this.repository);

  Future<AvisEntity> call({
    required String commerceId,
    required String auteurId,
    required String auteurNom,
    required String commentaire,
  }) {
    return repository.submitAvis(
      commerceId: commerceId,
      auteurId: auteurId,
      auteurNom: auteurNom,
      commentaire: commentaire,
    );
  }
}
