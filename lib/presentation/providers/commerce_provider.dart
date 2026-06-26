// Ce provider gère l’état des commerces (liste, chargement, erreur).

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/commerce_entity.dart';
import '../../domain/usecases/commerce/get_nearby_commerces_usecase.dart';
import '../../domain/usecases/commerce/get_my_commerces_usecase.dart';

class CommerceState {
  final bool isLoading;
  final List<CommerceEntity> commerces;
  final String? error;

  const CommerceState({
    this.isLoading = false,
    this.commerces = const [],
    this.error,
  });

  CommerceState copyWith({
    bool? isLoading,
    List<CommerceEntity>? commerces,
    String? error,
  }) {
    return CommerceState(
      isLoading: isLoading ?? this.isLoading,
      commerces: commerces ?? this.commerces,
      error: error,
    );
  }
}

class CommerceNotifier extends StateNotifier<CommerceState> {
  final GetNearbyCommercesUsecase getNearbyCommercesUsecase;
  final GetMyCommercesUsecase getMyCommercesUsecase;

  CommerceNotifier({
    required this.getNearbyCommercesUsecase,
    required this.getMyCommercesUsecase,
  }) : super(const CommerceState());

  Future<void> loadNearby({
    required double latitude,
    required double longitude,
    required double radiusKm,
    required String category,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final list = await getNearbyCommercesUsecase.call(
        latitude: latitude,
        longitude: longitude,
        radiusKm: radiusKm,
        category: category,
      );
      state = state.copyWith(isLoading: false, commerces: list);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadMyCommerces() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final list = await getMyCommercesUsecase.call();
      // TODO: typer correctement
      state = state.copyWith(isLoading: false, commerces: list.cast<CommerceEntity>());
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

// Provider de state : relie les usecases à un notifier Riverpod.
// IMPORTANT: Les usecases doivent être injectés (via DI) dans une étape suivante.
final commerceProvider = StateNotifierProvider<CommerceNotifier, CommerceState>((ref) {
  throw UnimplementedError('Connecter l’injection des usecases pour CommerceNotifier');
});

