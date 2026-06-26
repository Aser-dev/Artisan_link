// Ce use case récupère la liste des commerces appartenant à l’utilisateur connecté.

import '../../repositories/i_commerce_repository.dart';


class GetMyCommercesUsecase {
  final ICommerceRepository repo;

  GetMyCommercesUsecase(this.repo);

  Future<List<dynamic>> call() {
    // TODO: remplacez dynamic par CommerceEntity une fois typé correctement.
    return repo.getMyCommerces();
  }
}

