// lib/presentation/pages/artisan/creer_commerce_page.dart
// Page de création d'un nouveau commerce avec formulaire complet
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/auth_provider.dart';
import '../../../core/di/injection_container.dart';
import '../../../domain/entities/commerce_entity.dart';
import '../../../core/constants.dart';
import '../../../core/utils/validators.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/design_system.dart';

class CreerCommercePage extends ConsumerStatefulWidget {
  const CreerCommercePage({super.key});

  @override
  ConsumerState<CreerCommercePage> createState() => _CreerCommercePageState();
}

class _CreerCommercePageState extends ConsumerState<CreerCommercePage> {
  final _formKey = GlobalKey<FormState>();
  final _nomCtrl = TextEditingController();
  final _telephoneCtrl = TextEditingController();
  final _adresseCtrl = TextEditingController();
  final _horairesCtrl = TextEditingController();
  String? _categorie;
  double? _latitude;
  double? _longitude;
  bool _isLoading = false;
  bool _gpsCharge = false;

  @override
  void initState() {
    super.initState();
    _chargerGPS();
  }

  @override
  void dispose() {
    _nomCtrl.dispose();
    _telephoneCtrl.dispose();
    _adresseCtrl.dispose();
    _horairesCtrl.dispose();
    super.dispose();
  }

  Future<void> _chargerGPS() async {
    bool serviceActive = await Geolocator.isLocationServiceEnabled();
    if (!serviceActive) return;
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission != LocationPermission.whileInUse &&
        permission != LocationPermission.always) {
      return;
    }
    try {
      Position pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium);
      setState(() {
        _latitude = pos.latitude;
        _longitude = pos.longitude;
        _gpsCharge = true;
      });
    } catch (_) {
      setState(() => _gpsCharge = false);
    }
  }

  Future<void> _sauvegarder() async {
    if (!_formKey.currentState!.validate()) return;
    if (_categorie == null) {
      _snack('Veuillez sélectionner une catégorie.', error: true);
      return;
    }
    if (_latitude == null || _longitude == null) {
      _snack('Position GPS requise.', error: true);
      return;
    }
    HapticFeedback.lightImpact();
    setState(() => _isLoading = true);
    final user = ref.read(currentUserProvider);
    if (user == null) {
      setState(() => _isLoading = false);
      return;
    }
    try {
      final commerce = CommerceEntity(
        id: '',
        userId: user.id,
        nom: _nomCtrl.text.trim(),
        categorie: _categorie!,
        telephone: _telephoneCtrl.text.trim(),
        descriptionAdresse: _adresseCtrl.text.trim(),
        latitude: _latitude,
        longitude: _longitude,
        horaires: _horairesCtrl.text.trim(),
        photos: [],
        estPublie: false,
        noteMoyenne: 0,
        nombreAvis: 0,
        createdAt: DateTime.now(),
      );
      await ref.read(createCommerceUsecaseProvider).call(commerce: commerce);
      if (!mounted) return;
      setState(() => _isLoading = false);
      _snack('Commerce créé avec succès !');
      context.pop();
    } catch (e) {
      setState(() => _isLoading = false);
      _snack('Erreur : ${e.toString()}', error: true);
    }
  }

  void _snack(String msg, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: error ? AppTheme.erreur : AppTheme.accentSecondaire,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.fondPrincipal,
      appBar: AppBar(
        title: Text('Artisan BF',
            style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                color: AppTheme.textePrimaire)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded,
              color: AppTheme.textePrimaire),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Créer votre commerce',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textePrimaire,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Présentez votre savoir-faire à la communauté locale.',
                style: GoogleFonts.inter(
                    fontSize: 14, color: AppTheme.texteSecondaire),
              ),
              const SizedBox(height: 24),

              FormSection(
                icon: Icons.store_rounded,
                title: 'Informations générales',
                children: [
                  AppInput(
                    label: 'Nom du commerce',
                    hint: 'Ex: Ferronnerie d\'Art de Ouaga',
                    icon: Icons.store_rounded,
                    controller: _nomCtrl,
                    validator: Validators.nom,
                  ),
                  const SizedBox(height: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Catégorie',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.texteSecondaire,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _categorie,
                        hint: const Text('Sélectionnez un métier'),
                        dropdownColor: AppTheme.surfaceCard,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppTheme.textePrimaire,
                        ),
                        items: AppConstants.categories
                            .map((cat) => DropdownMenuItem(
                                  value: cat,
                                  child: Text(cat),
                                ))
                            .toList(),
                        onChanged: (val) =>
                            setState(() => _categorie = val),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppTheme.surfaceCard,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                                color: AppTheme.bordureSubtile),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Numéro de téléphone',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.texteSecondaire,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 14),
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceCard,
                              border: Border.all(
                                  color: AppTheme.bordureSubtile),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Text(
                              '+226',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textePrimaire,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              controller: _telephoneCtrl,
                              keyboardType: TextInputType.phone,
                              validator: Validators.telephone,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: AppTheme.textePrimaire,
                              ),
                              decoration: InputDecoration(
                                hintText: '70 00 00 00',
                                filled: true,
                                fillColor: AppTheme.surfaceCard,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(
                                      color: AppTheme.bordureSubtile),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  AppInput(
                    label: 'Adresse ou Quartier',
                    hint: 'Ex: Pissy, Rue des Artisans',
                    icon: Icons.location_on_rounded,
                    controller: _adresseCtrl,
                    maxLines: 2,
                    validator: (v) =>
                        v!.isEmpty ? 'Requis' : null,
                  ),
                  const SizedBox(height: 14),
                  AppInput(
                    label: 'Horaires',
                    hint: 'Ex: Lun-Sam 08:00-18:00',
                    icon: Icons.access_time_rounded,
                    controller: _horairesCtrl,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // GPS
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _gpsCharge
                      ? AppTheme.surfaceCard
                      : AppTheme.surfaceCardHover,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _gpsCharge
                        ? AppTheme.accentSecondaire
                        : AppTheme.bordureSubtile,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.gps_fixed_rounded,
                      color: _gpsCharge
                          ? AppTheme.accentPrimaire
                          : AppTheme.texteTertiaire,
                      size: 22,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Position GPS',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              color: _gpsCharge
                                  ? AppTheme.accentPrimaire
                                  : AppTheme.texteSecondaire,
                            ),
                          ),
                          Text(
                            _gpsCharge
                                ? '${_latitude?.toStringAsFixed(4)}, ${_longitude?.toStringAsFixed(4)}'
                                : 'En attente... Saisie manuelle possible',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppTheme.texteSecondaire,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!_gpsCharge)
                      TextButton(
                        onPressed: _chargerGPS,
                        child: Text(
                          'Réessayer',
                          style: GoogleFonts.inter(
                              color: AppTheme.accentPrimaire),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              PrimaryButton(
                label: 'Publier mon commerce',
                isLoading: _isLoading,
                onPressed: _sauvegarder,
                icon: Icons.check_circle_rounded,
              ),
              const SizedBox(height: 12),
              SecondaryButton(
                label: 'Annuler',
                onPressed: () => context.pop(),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}