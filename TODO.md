# TODO - Clean Architecture skeleton

## Étape 1 — Cartographie
- [x] Parcourir l’arborescence existante (lib/ et pubspec.yaml)
- [x] Lire/valider les fichiers déjà présents dans la liste demandée (partiel à ce stade)


## Étape 2 — Stubs Clean Architecture
- [ ] Créer/compléter toutes les routes de fichiers manquantes

- [ ] Ajouter entités/DTOs pures + repositories abstraits + use cases `call()`
- [ ] Ajouter datasources avec `throw UnimplementedError()`
- [ ] Ajouter providers Riverpod (StateNotifier/FutureProvider)
- [ ] Ajouter pages StatelessWidget basiques

## Étape 3 — Core
- [ ] Mettre à jour `constants.dart` avec la liste complète des catégories
- [ ] Vérifier/squeletter `injection_container.dart` et `supabase_client.dart`
- [ ] Vérifier/squeletter `app_theme.dart`

## Étape 4 — pubspec.yaml
- [ ] Mettre à jour `dependencies` et `dev_dependencies` selon la demande

## Étape 5 — Validation
- [ ] `flutter pub get`
- [ ] `flutter analyze`
- [ ] (optionnel) `flutter test`

