// lib/domain/repositories/i_commerce_repository.dart
import '../entities/commerce_entity.dart';

abstract class ICommerceRepository {
  Future<List<CommerceEntity>> getNearbyCommerces({
    required double latitude,
    required double longitude,
    double rayonKm = 5.0,
    String? categorie,
    double? noteMinimale,
  });

  Future<List<CommerceEntity>> searchCommerces({required String query});
  Future<CommerceEntity> getCommerceById({required String id});
  Future<List<CommerceEntity>> getMesCommerces({required String userId});
  Future<List<CommerceEntity>> getMyCommerces();

  Future<CommerceEntity> createCommerce({required CommerceEntity commerce});
  Future<CommerceEntity> updateCommerce({required CommerceEntity commerce});
  Future<void> togglePublication({
    required String commerceId,
    required bool publier,
  });
  Future<void> deleteCommerce({required String commerceId});
}
