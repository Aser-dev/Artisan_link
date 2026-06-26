import '../../repositories/i_commerce_repository.dart';

class CreateCommerceUsecase {
  final ICommerceRepository repo;

  CreateCommerceUsecase(this.repo);

  Future call({
    required String name,
    required String category,
    required double latitude,
    required double longitude,
    required String address,
    required String note,
  }) {
    return repo.createCommerce(
      name: name,
      category: category,
      latitude: latitude,
      longitude: longitude,
      address: address,
      note: note,
    );
  }
}
