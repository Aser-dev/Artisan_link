// lib/data/repositories/commerce_repository_impl.dart
import '../../domain/entities/commerce_entity.dart';
import '../../domain/repositories/i_commerce_repository.dart';
import '../datasources/remote/supabase_commerce_datasource.dart';
import '../models/commerce_dto.dart';

class CommerceRepositoryImpl implements ICommerceRepository {
  final SupabaseCommerceDatasource _remote;
  CommerceRepositoryImpl(this._remote);

  @override
  Future<List<CommerceEntity>> getNearbyCommerces({
    required double latitude,
    required double longitude,
    double rayonKm = 5.0,
    String? categorie,
    double? noteMinimale,
  }) async {
    final dtos = await _remote.getNearbyCommerces(
      latitude: latitude,
      longitude: longitude,
      rayonKm: rayonKm,
      categorie: categorie,
      noteMinimale: noteMinimale,
    );
    return dtos.map((d) => d.toEntity()).toList();
  }

  @override
  Future<List<CommerceEntity>> searchCommerces({required String query}) async {
    final dtos = await _remote.searchCommerces(query: query);
    return dtos.map((d) => d.toEntity()).toList();
  }

  @override
  Future<CommerceEntity> getCommerceById({required String id}) async {
    final dto = await _remote.getCommerceById(id: id);
    return dto.toEntity();
  }

  @override
  Future<List<CommerceEntity>> getMesCommerces({required String userId}) async {
    final dtos = await _remote.getMesCommerces(userId: userId);
    return dtos.map((d) => d.toEntity()).toList();
  }

  @override
  Future<List<CommerceEntity>> getMyCommerces() async {
    throw UnimplementedError('getMyCommerces() non implémenté');
  }


  @override
  Future<CommerceEntity> createCommerce({
    required CommerceEntity commerce,
  }) async {
    final dto = await _remote.createCommerce(
      dto: CommerceDto.fromEntity(commerce),
    );
    return dto.toEntity();
  }

  @override
  Future<CommerceEntity> updateCommerce({
    required CommerceEntity commerce,
  }) async {
    final dto = await _remote.updateCommerce(
      dto: CommerceDto.fromEntity(commerce),
    );
    return dto.toEntity();
  }

  @override
  Future<void> togglePublication({
    required String commerceId,
    required bool publier,
  }) {
    return _remote.togglePublication(commerceId: commerceId, publier: publier);
  }

  @override
  Future<void> deleteCommerce({required String commerceId}) {
    return _remote.deleteCommerce(commerceId: commerceId);
  }
}
