// lib/data/datasources/remote/supabase_commerce_datasource.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/commerce_dto.dart';

class SupabaseCommerceDatasource {
  final SupabaseClient _client;
  SupabaseCommerceDatasource(this._client);

  Future<List<CommerceDto>> getNearbyCommerces({
    required double latitude,
    required double longitude,
    double rayonKm = 5.0,
    String? categorie,
    double? noteMinimale,
  }) async {
    final minLat = latitude - (rayonKm / 111);
    final maxLat = latitude + (rayonKm / 111);
    final minLon = longitude - (rayonKm / 111);
    final maxLon = longitude + (rayonKm / 111);

    // IMPORTANT: l'API de filtrage dépend de la version supabase_flutter.
    // Ici on évite .eq/.gte/.lte/.filter non supportés par ton SDK.
    // Stratégie MVP: récupération d'abord (est_publie=true via query string)
    // puis filtrage local.

    final data = await _client
        .from('commerces')
        .select()
        .order('note_moyenne', ascending: false)
        .limit(200);

    final list = (data as List).map((e) => CommerceDto.fromJson(e)).toList();

    final filtered = list.where((c) {
      if (!c.estPublie) return false;
      if (categorie != null &&
          categorie.isNotEmpty &&
          c.categorie != categorie) {
        return false;
      }
      if (noteMinimale != null && c.noteMoyenne < noteMinimale) {
        return false;
      }
      if (c.latitude == null || c.longitude == null) return false;

      return c.latitude! >= minLat &&
          c.latitude! <= maxLat &&
          c.longitude! >= minLon &&
          c.longitude! <= maxLon;
    }).toList();

    return filtered;
  }

  Future<List<CommerceDto>> searchCommerces({required String query}) async {
    final data = await _client
        .from('commerces')
        .select()
        .eq('est_publie', true)
        .ilike('nom', '%$query%')
        .order('note_moyenne', ascending: false)
        .limit(20);
    return (data as List).map((e) => CommerceDto.fromJson(e)).toList();
  }

  Future<CommerceDto> getCommerceById({required String id}) async {
    final data = await _client.from('commerces').select().eq('id', id).single();
    return CommerceDto.fromJson(data);
  }

  Future<List<CommerceDto>> getMesCommerces({required String userId}) async {
    final data = await _client
        .from('commerces')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    return (data as List).map((e) => CommerceDto.fromJson(e)).toList();
  }

  Future<CommerceDto> createCommerce({required CommerceDto dto}) async {
    final data = await _client
        .from('commerces')
        .insert(dto.toJson())
        .select()
        .single();
    return CommerceDto.fromJson(data);
  }

  Future<CommerceDto> updateCommerce({required CommerceDto dto}) async {
    final data = await _client
        .from('commerces')
        .update(dto.toJson())
        .eq('id', dto.id)
        .select()
        .single();
    return CommerceDto.fromJson(data);
  }

  Future<void> togglePublication({
    required String commerceId,
    required bool publier,
  }) async {
    await _client
        .from('commerces')
        .update({'est_publie': publier})
        .eq('id', commerceId);
  }

  Future<void> deleteCommerce({required String commerceId}) async {
    await _client.from('commerces').delete().eq('id', commerceId);
  }
}
