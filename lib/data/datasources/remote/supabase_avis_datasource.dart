// lib/data/datasources/remote/supabase_avis_datasource.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/avis_dto.dart';

class SupabaseAvisDatasource {
  final SupabaseClient _client;
  SupabaseAvisDatasource(this._client);

  Future<AvisDto> submitAvis({
    required String commerceId,
    required String auteurId,
    required String auteurNom,
    required String commentaire,
  }) async {
    int noteIa = 3;
    String? raisonIa;

    try {
      final iaResponse = await _client.functions.invoke(
        'noter-avis',
        body: {'commentaire': commentaire},
      );
      if (iaResponse.data != null) {
        noteIa = (iaResponse.data['note'] as num).toInt().clamp(1, 5);
        raisonIa = iaResponse.data['raison'] as String?;
      }
    } catch (_) {}

    final data = await _client
        .from('avis')
        .insert({
          'commerce_id': commerceId,
          'auteur_id': auteurId,
          'auteur_nom': auteurNom,
          'commentaire': commentaire,
          'note_ia': noteIa,
          'raison_ia': raisonIa,
        })
        .select()
        .single();

    await _updateNoteMoyenne(commerceId);
    return AvisDto.fromJson(data);
  }

  Future<List<AvisDto>> getAvisCommerce({required String commerceId}) async {
    final data = await _client
        .from('avis')
        .select()
        .eq('commerce_id', commerceId)
        .order('created_at', ascending: false);
    return (data as List).map((e) => AvisDto.fromJson(e)).toList();
  }

  Future<void> signalerCommerce({
    required String commerceId,
    required String raison,
  }) async {
    await _client.from('signalements').insert({
      'commerce_id': commerceId,
      'raison': raison,
    });
  }

  Future<void> _updateNoteMoyenne(String commerceId) async {
    final avis = await _client
        .from('avis')
        .select('note_ia')
        .eq('commerce_id', commerceId);
    if ((avis as List).isEmpty) return;
    final total = avis.fold<int>(0, (sum, a) => sum + (a['note_ia'] as int));
    final moyenne = total / avis.length;
    await _client
        .from('commerces')
        .update({
          'note_moyenne': double.parse(moyenne.toStringAsFixed(1)),
          'nombre_avis': avis.length,
        })
        .eq('id', commerceId);
  }
}
