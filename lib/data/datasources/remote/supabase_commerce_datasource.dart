import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseCommerceDatasource {
  final SupabaseClient client;

  SupabaseCommerceDatasource(this.client);

  // IMPORTANT: Table/column names may need alignment with your schema.

  Future<List<Map<String, dynamic>>> getNearby({
    required double latitude,
    required double longitude,
    required double radiusKm,
    required String category,
  }) async {
    // TODO: Implement geospatial query based on your schema.
    // Placeholder: simple filter by category.
    final response = await client
        .from('commerces')
        .select()
        .eq('category', category);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> getMyCommerces() async {
    final user = client.auth.currentUser;
    if (user == null) throw StateError('Not authenticated');

    final response = await client
        .from('commerces')
        .select()
        .eq('owner_id', user.id);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<Map<String, dynamic>> createCommerce({
    required String ownerId,
    required String name,
    required String category,
    required double latitude,
    required double longitude,
    required String address,
    required String note,
  }) async {
    final response = await client
        .from('commerces')
        .insert({
          'owner_id': ownerId,
          'name': name,
          'category': category,
          'latitude': latitude,
          'longitude': longitude,
          'address': address,
          'note': note,
          'is_published': false,
        })
        .select()
        .single();

    return Map<String, dynamic>.from(response);
  }

  Future<Map<String, dynamic>> updateCommerce({
    required String commerceId,
    required String name,
    required String category,
    required double latitude,
    required double longitude,
    required String address,
    required String note,
  }) async {
    final response = await client
        .from('commerces')
        .update({
          'name': name,
          'category': category,
          'latitude': latitude,
          'longitude': longitude,
          'address': address,
          'note': note,
        })
        .eq('id', commerceId)
        .select()
        .single();

    return Map<String, dynamic>.from(response);
  }

  Future<void> togglePublication({
    required String commerceId,
    required bool publish,
  }) async {
    await client
        .from('commerces')
        .update({'is_published': publish})
        .eq('id', commerceId);
  }

  Future<Map<String, dynamic>?> getCommerceById({
    required String commerceId,
  }) async {
    final response = await client
        .from('commerces')
        .select()
        .eq('id', commerceId)
        .maybeSingle();

    return response == null ? null : Map<String, dynamic>.from(response);
  }
}
