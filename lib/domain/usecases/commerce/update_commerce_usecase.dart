import '../../entities/commerce_entity.dart';
import '../../repositories/i_commerce_repository.dart';


class UpdateCommerceUsecase {
  final ICommerceRepository repo;

  UpdateCommerceUsecase(this.repo);

  Future<CommerceEntity> call({
    required String id,
    required String name,
    required String category,
    required double latitude,
    required double longitude,
    required String address,
    required String note,
  }) {
    return repo.updateCommerce(
      id: id,
      name: name,
      category: category,
      latitude: latitude,
      longitude: longitude,
      address: address,
      note: note,
    );
  }
}
