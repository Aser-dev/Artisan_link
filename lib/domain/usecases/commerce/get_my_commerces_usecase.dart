// Ce use case récupère la liste des commerces appartenant à l’utilisateur connecté.

import '../../repositories/i_commerce_repository.dart';
import '../../entities/commerce_entity.dart';

class GetMyCommercesUsecase {
  final ICommerceRepository repo;

  GetMyCommercesUsecase(this.repo);

  Future<List<CommerceEntity>> call() async {
    return repo.getMyCommerces();
  }
}
