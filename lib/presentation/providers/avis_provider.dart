import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/injection_container.dart';
import '../../domain/entities/avis_entity.dart';
import 'auth_provider.dart';

class AvisState {
  final bool isLoading;
  final bool succes;
  final String? erreur;
  final AvisEntity? dernierAvis;

  const AvisState({
    this.isLoading = false,
    this.succes = false,
    this.erreur,
    this.dernierAvis,
  });

  AvisState copyWith({
    bool? isLoading,
    bool? succes,
    String? erreur,
    AvisEntity? dernierAvis,
    bool clearErreur = false,
  }) {
    return AvisState(
      isLoading: isLoading ?? this.isLoading,
      succes: succes ?? this.succes,
      erreur: clearErreur ? null : (erreur ?? this.erreur),
      dernierAvis: dernierAvis ?? this.dernierAvis,
    );
  }
}

class AvisNotifier extends StateNotifier<AvisState> {
  final Ref _ref;

  AvisNotifier(this._ref) : super(const AvisState());

  Future<void> soumettre({
    required String commerceId,
    required String commentaire,
  }) async {
    final user = _ref.read(currentUserProvider);
    if (user == null) return;

    state = state.copyWith(isLoading: true, clearErreur: true, succes: false);

    try {
      final avis = await _ref
          .read(submitAvisUsecaseProvider)
          .call(
            commerceId: commerceId,
            auteurId: user.id,
            auteurNom: user.nom,
            commentaire: commentaire,
          );

      state = state.copyWith(isLoading: false, succes: true, dernierAvis: avis);
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        erreur: 'Impossible de soumettre votre avis.',
      );
    }
  }

  void reset() => state = const AvisState();
}

final avisProvider = StateNotifierProvider<AvisNotifier, AvisState>((ref) {
  return AvisNotifier(ref);
});

final avisListProvider = FutureProvider.family<List<AvisEntity>, String>((
  ref,
  commerceId,
) async {
  return ref
      .read(avisRepositoryProvider)
      .getAvisCommerce(commerceId: commerceId);
});
