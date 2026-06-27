// lib/core/constants.dart
import 'package:latlong2/latlong.dart';

class AppConstants {
  // Rôles
  static const String roleArtisan = 'artisan';
  static const String roleCitoyen = 'citoyen';

  // Position par défaut (Ouagadougou)
  static const LatLng ouagadougouCentre = LatLng(12.3714, -1.5347);

  // Catégories d'artisans
  static const List<String> categories = [
    'Mécanicien',
    'Couturier',
    'Coiffeur',
    'Soudeur',
    'Électricien',
    'Menuisier',
    'Plombier',
    'Réparateur téléphone',
  ];

  // Messages d'erreur
  static const String erreurConnexion = 'Impossible de se connecter au serveur.';
  static const String erreurChampsVides = 'Veuillez remplir tous les champs.';
  static const String erreurEmailInvalide = 'Adresse email invalide.';
  static const String erreurMotDePasseCourt = 'Le mot de passe doit contenir au moins 6 caractères.';
}