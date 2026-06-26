import '../../domain/entities/commerce_entity.dart';
import '../../domain/repositories/i_commerce_repository.dart';
import '../datasources/remote/supabase_commerce_datasource.dart';
import '../models/commerce_dto.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

class CommerceRepositoryImpl implements ICommerceRepository {
  final SupabaseCommerceDatasource ds;

  CommerceRepositoryImpl(this.ds);

  SupabaseClient get _client => ds.client;

  @override
  Future<List<CommerceEntity>> getNearby({
    required double latitude,
    required double longitude,
    required double radiusKm,
    required String category,
  }) async {
    final rows = await ds.getNearby(
      latitude: latitude,
      longitude: longitude,
      radiusKm: radiusKm,
      category: category,
    );

    return rows.map((e) => CommerceDto.fromMap(e).toEntity()).toList();
  }

  @override
  Future<List<CommerceEntity>> getMyCommerces() async {
    final rows = await ds.getMyCommerces();
    return rows.map((e) => CommerceDto.fromMap(e).toEntity()).toList();
  }

  @override
  Future<CommerceEntity> createCommerce({
    required String name,
    required String category,
    required double latitude,
    required double longitude,
    required String address,
    required String note,
  }) async {
    final ownerId = _client.auth.currentUser?.id;
    if (ownerId == null) {
      throw StateError('Not authenticated');
    }

    final row = await ds.createCommerce(
      ownerId: ownerId,
      name: name,
      category: category,
      latitude: latitude,
      longitude: longitude,
      address: address,
      note: note,
    );

    return CommerceDto.fromMap(row).toEntity();
  }

  @override
  Future<CommerceEntity> updateCommerce({
    required String id,
    required String name,
    required String category,
    required double latitude,
    required double longitude,
    required String address,
    required String note,
  }) async {
    final row = await ds.updateCommerce(
      commerceId: id,
      name: name,
      category: category,
      latitude: latitude,
      longitude: longitude,
      address: address,
      note: note,
    );

    return CommerceDto.fromMap(row).toEntity();
  }

  @override
  Future<void> togglePublication({
    required String id,
    required bool publish,
  }) async {
    await ds.togglePublication(commerceId: id, publish: publish);
  }

  @override
  Future<CommerceEntity?> getCommerceById({required String id}) async {
    final row = await ds.getCommerceById(commerceId: id);
    if (row == null) return null;
    return CommerceDto.fromMap(row).toEntity();
  }
}
