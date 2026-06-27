// lib/data/repositories/avis_repository_impl.dart
import '../../domain/entities/avis_entity.dart';
import '../../domain/repositories/i_avis_repository.dart';
import '../datasources/remote/supabase_avis_datasource.dart';

class AvisRepositoryImpl implements IAvisRepository {
  final SupabaseAvisDatasource _remote;
  AvisRepositoryImpl(this._remote);

  @override
  Future<AvisEntity> submitAvis({
    required String commerceId,
    required String auteurId,
    required String auteurNom,
    required String commentaire,
  }) async {
    final dto = await _remote.submitAvis(
      commerceId: commerceId,
      auteurId: auteurId,
      auteurNom: auteurNom,
      commentaire: commentaire,
    );
    return dto.toEntity();
  }

  @override
  Future<List<AvisEntity>> getAvisCommerce({required String commerceId}) async {
    final dtos = await _remote.getAvisCommerce(commerceId: commerceId);
    return dtos.map((d) => d.toEntity()).toList();
  }

  @override
  Future<void> signalerCommerce({
    required String commerceId,
    required String raison,
  }) {
    return _remote.signalerCommerce(commerceId: commerceId, raison: raison);
  }
}
