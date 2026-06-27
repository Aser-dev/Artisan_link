// lib/domain/repositories/i_avis_repository.dart
import '../entities/avis_entity.dart';

abstract class IAvisRepository {
  Future<AvisEntity> submitAvis({
    required String commerceId,
    required String auteurId,
    required String auteurNom,
    required String commentaire,
  });

  Future<List<AvisEntity>> getAvisCommerce({required String commerceId});
  Future<void> signalerCommerce({
    required String commerceId,
    required String raison,
  });
}
