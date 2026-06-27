// lib/domain/usecases/avis/get_avis_commerce_usecase.dart
import '../../entities/avis_entity.dart';
import '../../repositories/i_avis_repository.dart';

class GetAvisCommerceUsecase {
  final IAvisRepository repository;
  const GetAvisCommerceUsecase(this.repository);

  Future<List<AvisEntity>> call({required String commerceId}) {
    return repository.getAvisCommerce(commerceId: commerceId);
  }
}
