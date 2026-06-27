// lib/domain/usecases/commerce/get_nearby_commerces_usecase.dart
import '../../entities/commerce_entity.dart';
import '../../repositories/i_commerce_repository.dart';

class GetNearbyCommercesUsecase {
  final ICommerceRepository repository;
  const GetNearbyCommercesUsecase(this.repository);

  Future<List<CommerceEntity>> call({
    required double latitude,
    required double longitude,
    double rayonKm = 5.0,
    String? categorie,
    double? noteMinimale,
  }) {
    return repository.getNearbyCommerces(
      latitude: latitude,
      longitude: longitude,
      rayonKm: rayonKm,
      categorie: categorie,
      noteMinimale: noteMinimale,
    );
  }
}