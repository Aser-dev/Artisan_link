// lib/domain/usecases/commerce/create_commerce_usecase.dart
import '../../entities/commerce_entity.dart';
import '../../repositories/i_commerce_repository.dart';

class CreateCommerceUsecase {
  final ICommerceRepository repository;
  const CreateCommerceUsecase(this.repository);

  Future<CommerceEntity> call({required CommerceEntity commerce}) {
    return repository.createCommerce(commerce: commerce);
  }
}
