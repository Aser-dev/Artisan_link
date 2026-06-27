// lib/presentation/pages/artisan/creer_commerce_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:geolocator/geolocator.dart';
import '../../providers/commerce_provider.dart';
import '../../providers/auth_provider.dart';
import '../../../core/di/injection_container.dart';
import '../../../domain/entities/commerce_entity.dart';
import '../../../core/constants.dart';
import '../../../core/utils/validators.dart';

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
    if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) return;
    try {
      Position pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
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
      _showSnack('Veuillez sélectionner une catégorie.', isError: true);
      return;
    }
    if (_latitude == null || _longitude == null) {
      _showSnack('Position GPS requise. Activez votre GPS.', isError: true);
      return;
    }
    setState(() => _isLoading = true);
    final user = ref.read(currentUserProvider);
    if (user == null) { setState(() => _isLoading = false); return; }
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
      setState(() => _isLoading = false);
      _showSnack('✅ Commerce créé avec succès !');
      context.pop();
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnack('❌ Erreur : ${e.toString()}', isError: true);
    }
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: isError ? Colors.red[700] : Colors.green[700]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        title: const Text('Nouveau commerce', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        foregroundColor: const Color(0xFF1E1E1E),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildSection(
                title: 'Informations générales',
                icon: Icons.store_rounded,
                children: [
                  _buildField('Nom commercial', _nomCtrl, hint: 'Ex: Atelier Kadiogo Design', validator: Validators.nom),
                  const SizedBox(height: 16),
                  _buildLabel('Catégorie'),
                  DropdownButtonFormField<String>(
                    value: _categorie,
                    hint: const Text('Sélectionner une catégorie'),
                    items: AppConstants.categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
                    onChanged: (val) => setState(() => _categorie = val),
                    decoration: const InputDecoration(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildSection(
                title: 'Contact',
                icon: Icons.phone_rounded,
                children: [
                  _buildLabel('Téléphone'),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                        decoration: BoxDecoration(color: const Color(0xFFF1F3F5), borderRadius: BorderRadius.circular(12)),
                        child: const Text('🇧🇫 +226', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          controller: _telephoneCtrl,
                          keyboardType: TextInputType.phone,
                          validator: Validators.telephone,
                          decoration: const InputDecoration(hintText: '70 00 00 00'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildSection(
                title: 'Localisation',
                icon: Icons.location_on_rounded,
                children: [
                  _buildField('Adresse descriptive', _adresseCtrl,
                    hint: 'Ex: Zone du Bois, côté goudron',
                    maxLines: 2,
                    validator: (v) => v!.isEmpty ? 'Requis' : null,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: _gpsCharge ? Colors.green[50] : Colors.orange[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _gpsCharge ? Colors.green[200]! : Colors.orange[200]!),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.gps_fixed_rounded, color: _gpsCharge ? Colors.green[700] : Colors.orange[700], size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Position GPS', style: TextStyle(fontWeight: FontWeight.bold, color: _gpsCharge ? Colors.green[700] : Colors.orange[700])),
                              Text(
                                _gpsCharge
                                    ? 'Lat: ${_latitude?.toStringAsFixed(4)} — Lon: ${_longitude?.toStringAsFixed(4)}'
                                    : 'En attente de la position...',
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        if (!_gpsCharge)
                          TextButton(onPressed: _chargerGPS, child: const Text('Réessayer')),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildSection(
                title: 'Horaires',
                icon: Icons.access_time_rounded,
                children: [
                  _buildField('Horaires d\'ouverture', _horairesCtrl, hint: 'Ex: Lun-Sam 08:00-18:00'),
                ],
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _sauvegarder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8CD82C),
                    foregroundColor: const Color(0xFF1E1E1E),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: _isLoading
                      ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(color: Color(0xFF1E1E1E), strokeWidth: 2))
                      : const Text('Enregistrer le commerce', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required IconData icon, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE9ECEF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: const Color(0xFFF1F3F5), borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, size: 18, color: const Color(0xFF2E4A0B)),
              ),
              const SizedBox(width: 10),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildField(String label, TextEditingController ctrl, {String? hint, int maxLines = 1, String? Function(String?)? validator}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        TextFormField(controller: ctrl, maxLines: maxLines, validator: validator, decoration: InputDecoration(hintText: hint)),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
    );
  }
}
