import '../../entities/commerce_entity.dart';
import '../../repositories/i_commerce_repository.dart';

class GetNearbyCommercesUsecase {
  final ICommerceRepository repo;

  GetNearbyCommercesUsecase(this.repo);

  Future<List<CommerceEntity>> call({
    required double latitude,
    required double longitude,
    required double radiusKm,
    required String category,
  }) {
    return repo.getNearby(
      latitude: latitude,
      longitude: longitude,
      radiusKm: radiusKm,
      category: category,
    );
  }
}
