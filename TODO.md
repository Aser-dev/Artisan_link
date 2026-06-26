# TODO - Implémentation architecture artisan_bf

## Étape 1 — Préparation deps
- [x] Mettre à jour `pubspec.yaml` : ajouter Riverpod, Supabase, SharedPreferences


## Étape 2 — Core
- [x] Créer `lib/core/di/injection_container.dart`
- [x] Créer `lib/core/network/supabase_client.dart`
- [x] Créer `lib/core/utils/constants.dart`, `formatter.dart`, `validators.dart`
- [x] Créer `lib/core/theme/app_theme.dart`


## Étape 3 — Domain
- [ ] Créer `lib/domain/entities/*.dart`
- [ ] Créer `lib/domain/repositories/i_*.dart`
- [ ] Créer `lib/domain/usecases/**_usecase.dart`

## Étape 4 — Data
- [ ] Créer `lib/data/datasources/remote/supabase_*_datasource.dart`
- [ ] Créer `lib/data/datasources/local/shared_prefs_datasource.dart`
- [ ] Créer `lib/data/models/*_dto.dart`
- [ ] Créer `lib/data/repositories/*_repository_impl.dart`

## Étape 5 — Presentation
- [ ] Créer providers Riverpod : `auth_provider.dart`, `commerce_provider.dart`, `avis_provider.dart`
- [x] Créer pages : `splash_page.dart`, `login_page.dart`, `register_page.dart`, `onboarding_page.dart`

- [ ] Créer widgets : `loading_indicator.dart`, `custom_app_bar.dart`, `commerce_card.dart`, `rating_stars.dart`

## Étape 6 — Wiring
- [x] Remplacer `lib/main.dart` par `ProviderScope` + `SplashPage`
- [ ] Créer providers/clients/rest of presentation (placeholders)




## Étape 7 — Validation
- [ ] `flutter pub get`
- [ ] `flutter analyze`
- [ ] `flutter run`

