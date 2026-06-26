// Ce provider gère l’état des avis (chargement, succès, erreur).

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/avis_entity.dart';
import '../../domain/usecases/avis/submit_avis_usecase.dart';

class AvisState {
  final bool isLoading;
  final AvisEntity? submittedAvis;
  final String? error;

  const AvisState({
    this.isLoading = false,
    this.submittedAvis,
    this.error,
  });

  AvisState copyWith({
    bool? isLoading,
    AvisEntity? submittedAvis,
    String? error,
    bool clearSubmitted = false,
  }) {
    return AvisState(
      isLoading: isLoading ?? this.isLoading,
      submittedAvis: clearSubmitted ? null : (submittedAvis ?? this.submittedAvis),
      error: error,
    );
  }
}

class AvisNotifier extends StateNotifier<AvisState> {
  final SubmitAvisUsecase submitAvisUsecase;

  AvisNotifier({required this.submitAvisUsecase}) : super(const AvisState());

  Future<void> submit({
    required String commerceId,
    required String commentaire,
  }) async {
    state = state.copyWith(isLoading: true, error: null, clearSubmitted: true);
    try {
      final avis = await submitAvisUsecase.call(
        commerceId: commerceId,
        commentaire: commentaire,
      );
      state = state.copyWith(isLoading: false, submittedAvis: avis);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final avisProvider = StateNotifierProvider<AvisNotifier, AvisState>((ref) {
  throw UnimplementedError('Connecter l’injection du SubmitAvisUsecase pour AvisNotifier');
});

