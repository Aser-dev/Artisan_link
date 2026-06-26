import '../../domain/entities/avis_entity.dart';
import '../../domain/repositories/i_avis_repository.dart';
import '../datasources/remote/supabase_avis_datasource.dart';
import '../models/avis_dto.dart';

class AvisRepositoryImpl implements IAvisRepository {
  final SupabaseAvisDatasource ds;

  AvisRepositoryImpl(this.ds);

  @override
  Future<AvisEntity> submitAvis({
    required String commerceId,
    required String commentaire,
  }) async {
    final row = await ds.submitAvis(
      commerceId: commerceId,
      commentaire: commentaire,
    );

    return AvisDto.fromMap(row).toEntity();
  }
}
