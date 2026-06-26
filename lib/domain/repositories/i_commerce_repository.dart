import '../entities/commerce_entity.dart';

abstract class ICommerceRepository {
  Future<List<CommerceEntity>> getNearby({
    required double latitude,
    required double longitude,
    required double radiusKm,
    required String category,
  });

  Future<List<CommerceEntity>> getMyCommerces();

  Future<CommerceEntity> createCommerce({
    required String name,
    required String category,
    required double latitude,
    required double longitude,
    required String address,
    required String note,
  });

  Future<CommerceEntity> updateCommerce({
    required String id,
    required String name,
    required String category,
    required double latitude,
    required double longitude,
    required String address,
    required String note,
  });

  Future<void> togglePublication({
    required String id,
    required bool publish,
  });

  Future<CommerceEntity?> getCommerceById({required String id});
}

