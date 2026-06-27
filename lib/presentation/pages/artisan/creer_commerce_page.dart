// lib/presentation/pages/artisan/creer_commerce_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:geolocator/geolocator.dart';
import '../../providers/auth_provider.dart';
import '../../../core/di/injection_container.dart';
import '../../../domain/entities/commerce_entity.dart';
import '../../../core/constants.dart';
import '../../../core/utils/validators.dart';
import '../../../core/theme/app_theme.dart';

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
    if (permission == LocationPermission.denied) permission = await Geolocator.requestPermission();
    if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) return;
    try {
      Position pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
      setState(() { _latitude = pos.latitude; _longitude = pos.longitude; _gpsCharge = true; });
    } catch (_) { setState(() => _gpsCharge = false); }
  }

  Future<void> _sauvegarder() async {
    if (!_formKey.currentState!.validate()) return;
    if (_categorie == null) { _snack('Veuillez sélectionner une catégorie.', error: true); return; }
    if (_latitude == null || _longitude == null) { _snack('Position GPS requise.', error: true); return; }
    setState(() => _isLoading = true);
    final user = ref.read(currentUserProvider);
    if (user == null) { setState(() => _isLoading = false); return; }
    try {
      final commerce = CommerceEntity(
        id: '', userId: user.id, nom: _nomCtrl.text.trim(), categorie: _categorie!,
        telephone: _telephoneCtrl.text.trim(), descriptionAdresse: _adresseCtrl.text.trim(),
        latitude: _latitude, longitude: _longitude, horaires: _horairesCtrl.text.trim(),
        photos: [], estPublie: false, noteMoyenne: 0, nombreAvis: 0, createdAt: DateTime.now(),
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
      backgroundColor: error ? AppTheme.error : AppTheme.primaryContainer,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.neutralSand,
      appBar: AppBar(
        title: const Text('Artisan Core'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppTheme.primary),
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
              const Text('Créer votre commerce', style: TextStyle(fontFamily: 'Hanken Grotesk', fontSize: 24, fontWeight: FontWeight.w700, color: AppTheme.onSurface)),
              const SizedBox(height: 4),
              const Text('Présentez votre savoir-faire à la communauté locale.', style: TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 14)),
              const SizedBox(height: 24),

              // Infos principales
              _buildCard(children: [
                _buildField(label: 'Nom du commerce', icon: Icons.store_rounded, child:
                  TextFormField(controller: _nomCtrl, validator: Validators.nom,
                    decoration: const InputDecoration(hintText: 'Ex: Ferronnerie d\'Art de Ouaga'))),
                const SizedBox(height: 16),
                _buildField(label: 'Catégorie', icon: Icons.category_rounded, child:
                  DropdownButtonFormField<String>(initialValue: _categorie,
                    hint: const Text('Sélectionnez un métier'),
                    items: AppConstants.categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
                    onChanged: (val) => setState(() => _categorie = val),
                    decoration: const InputDecoration(),
                  )),
                const SizedBox(height: 16),
                _buildField(label: 'Numéro de téléphone', icon: Icons.call_rounded, child:
                  Row(children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      decoration: BoxDecoration(border: Border.all(color: AppTheme.outline), borderRadius: BorderRadius.circular(8)),
                      child: const Text('+226', style: TextStyle(fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: TextFormField(controller: _telephoneCtrl, keyboardType: TextInputType.phone, validator: Validators.telephone,
                      decoration: const InputDecoration(hintText: '70 00 00 00'))),
                  ])),
                const SizedBox(height: 16),
                _buildField(label: 'Adresse ou Quartier', icon: Icons.location_on_rounded, child:
                  TextFormField(controller: _adresseCtrl, maxLines: 2, validator: (v) => v!.isEmpty ? 'Requis' : null,
                    decoration: const InputDecoration(hintText: 'Ex: Pissy, Rue des Artisans'))),
                const SizedBox(height: 16),
                _buildField(label: 'Horaires', icon: Icons.access_time_rounded, child:
                  TextFormField(controller: _horairesCtrl, decoration: const InputDecoration(hintText: 'Ex: Lun-Sam 08:00-18:00'))),
              ]),
              const SizedBox(height: 16),

              // GPS
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _gpsCharge ? AppTheme.surfaceContainerLow : AppTheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _gpsCharge ? AppTheme.primaryContainer.withValues(alpha: 0.4) : AppTheme.outlineVariant),
                ),
                child: Row(
                  children: [
                    Icon(Icons.gps_fixed_rounded, color: _gpsCharge ? AppTheme.primaryContainer : AppTheme.outline, size: 22),
                    const SizedBox(width: 12),
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Position GPS', style: TextStyle(fontWeight: FontWeight.w600, color: _gpsCharge ? AppTheme.primaryContainer : AppTheme.onSurfaceVariant)),
                        Text(_gpsCharge ? '${_latitude?.toStringAsFixed(4)}, ${_longitude?.toStringAsFixed(4)}' : 'En attente...', style: const TextStyle(fontSize: 12, color: AppTheme.onSurfaceVariant)),
                      ],
                    )),
                    if (!_gpsCharge) TextButton(onPressed: _chargerGPS, child: const Text('Réessayer')),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _sauvegarder,
                  child: _isLoading
                      ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(color: AppTheme.onPrimary, strokeWidth: 2))
                      : const Text('Publier mon commerce', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: () => context.pop(),
                  style: OutlinedButton.styleFrom(side: const BorderSide(color: AppTheme.outlineVariant)),
                  child: const Text('Annuler', style: TextStyle(color: AppTheme.onSurfaceVariant)),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.outlineVariant.withValues(alpha: 0.3)),
        boxShadow: [BoxShadow(color: AppTheme.primary.withValues(alpha: 0.04), blurRadius: 12)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }

  Widget _buildField({required String label, required IconData icon, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Icon(icon, size: 18, color: AppTheme.primary),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppTheme.onSurface)),
        ]),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}


