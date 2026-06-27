// lib/domain/usecases/commerce/update_commerce_usecase.dart
import '../../entities/commerce_entity.dart';
import '../../repositories/i_commerce_repository.dart';

class UpdateCommerceUsecase {
  final ICommerceRepository repository;
  const UpdateCommerceUsecase(this.repository);

  Future<CommerceEntity> call({required CommerceEntity commerce}) {
    return repository.updateCommerce(commerce: commerce);
  }
}
