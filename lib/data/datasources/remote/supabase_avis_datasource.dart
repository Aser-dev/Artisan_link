import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAvisDatasource {
  final SupabaseClient client;

  SupabaseAvisDatasource(this.client);

  Future<Map<String, dynamic>> submitAvis({
    required String commerceId,
    required String commentaire,
  }) async {
    // Expected Edge Function contract: noter-avis
    // You MUST adjust payload/return parsing to match your edge function.

    final response = await client.functions.invoke(
      'noter-avis',
      body: {
        'commerceId': commerceId,
        'commentaire': commentaire,
      },
    );

    final payload = response.data;

    if (payload is Map<String, dynamic>) {
      // Insert avis into table
      final noteIA = (payload['noteIA'] ?? payload['note'] ?? 0).toDouble();
      final inserted = await client.from('avis').insert({
        'commerce_id': commerceId,
        'commentaire': commentaire,
        'note_ia': noteIA,
      }).select().single();

      return Map<String, dynamic>.from(inserted);
    }

    throw StateError('Unexpected function response for noter-avis');
  }
}

