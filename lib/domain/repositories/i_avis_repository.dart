import '../entities/avis_entity.dart';

abstract class IAvisRepository {
  Future<AvisEntity> submitAvis({
    required String commerceId,
    required String commentaire,
  });
}

