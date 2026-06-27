// lib/presentation/providers/commerce_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/commerce_entity.dart';
import '../../core/di/injection_container.dart';
import 'auth_provider.dart';


class CommerceState {
  final List<CommerceEntity> commerces;
  final bool isLoading;
  final String? erreur;
  final String? categorieSelectee;
  final double? noteMinimale;

  const CommerceState({
    this.commerces = const [],
    this.isLoading = false,
    this.erreur,
    this.categorieSelectee,
    this.noteMinimale,
  });

  CommerceState copyWith({
    List<CommerceEntity>? commerces,
    bool? isLoading,
    String? erreur,
    String? categorieSelectee,
    double? noteMinimale,
    bool clearErreur = false,
    bool clearCategorie = false,
  }) {
    return CommerceState(
      commerces: commerces ?? this.commerces,
      isLoading: isLoading ?? this.isLoading,
      erreur: clearErreur ? null : erreur ?? this.erreur,
      categorieSelectee: clearCategorie ? null : categorieSelectee ?? this.categorieSelectee,
      noteMinimale: noteMinimale ?? this.noteMinimale,
    );
  }
}

class CommerceNotifier extends StateNotifier<CommerceState> {
  final Ref _ref;
  CommerceNotifier(this._ref) : super(const CommerceState());

  Future<void> chargerProches({
    required double latitude,
    required double longitude,
  }) async {
    state = state.copyWith(isLoading: true, clearErreur: true);
    try {
      final commerces = await _ref.read(getNearbyCommercesUsecaseProvider).call(
        latitude: latitude,
        longitude: longitude,
        categorie: state.categorieSelectee,
        noteMinimale: state.noteMinimale,
      );
      state = state.copyWith(commerces: commerces, isLoading: false);
    } catch (_) {
      state = state.copyWith(isLoading: false, erreur: 'Impossible de charger les artisans.');
    }
  }

  Future<void> rechercher({required String query}) async {
    if (query.isEmpty) return;
    state = state.copyWith(isLoading: true, clearErreur: true);
    try {
      final commerces = await _ref.read(commerceRepositoryProvider).searchCommerces(query: query);
      state = state.copyWith(commerces: commerces, isLoading: false);
    } catch (_) {
      state = state.copyWith(isLoading: false, erreur: 'Recherche échouée.');
    }
  }

  void filtrerParCategorie(String? categorie) {
    state = state.copyWith(categorieSelectee: categorie, clearCategorie: categorie == null);
  }

  void filtrerParNote(double? note) {
    state = state.copyWith(noteMinimale: note);
  }

  Future<void> togglePublication({required String commerceId, required bool publier}) async {
    try {
      await _ref.read(togglePublicationUsecaseProvider).call(
        commerceId: commerceId,
        publier: publier,
      );
      final updated = state.commerces.map((c) {
        return c.id == commerceId ? c.copyWith(estPublie: publier) : c;
      }).toList();
      state = state.copyWith(commerces: updated);
    } catch (_) {
      state = state.copyWith(erreur: 'Action échouée.');
    }
  }
}

final commerceProvider = StateNotifierProvider<CommerceNotifier, CommerceState>((ref) {
  return CommerceNotifier(ref);
});

final mesCommercesProvider = FutureProvider<List<CommerceEntity>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];
  return ref.read(commerceRepositoryProvider).getMesCommerces(userId: user.id);
});

final commerceDetailProvider = FutureProvider.family<CommerceEntity, String>((ref, id) async {
  return ref.read(commerceRepositoryProvider).getCommerceById(id: id);
});