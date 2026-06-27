// lib/presentation/pages/artisan/editer_commerce_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/commerce_provider.dart';
import '../../providers/auth_provider.dart';
import '../../../core/di/injection_container.dart';
import '../../../domain/entities/commerce_entity.dart';
import '../../../core/constants.dart';
import '../../../core/utils/validators.dart';
import '../../../core/theme/app_theme.dart';

class EditerCommercePage extends ConsumerStatefulWidget {
  final String commerceId;
  const EditerCommercePage({super.key, required this.commerceId});

  @override
  ConsumerState<EditerCommercePage> createState() => _EditerCommercePageState();
}

class _EditerCommercePageState extends ConsumerState<EditerCommercePage> {
  final _formKey = GlobalKey<FormState>();
  final _nomCtrl = TextEditingController();
  final _telephoneCtrl = TextEditingController();
  final _adresseCtrl = TextEditingController();
  final _horairesCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  String? _categorie;
  bool _isLoading = false;
  bool _isInit = false;

  @override
  void dispose() {
    _nomCtrl.dispose(); _telephoneCtrl.dispose();
    _adresseCtrl.dispose(); _horairesCtrl.dispose();
    _descriptionCtrl.dispose();
    super.dispose();
  }

  void _initFromCommerce(CommerceEntity c) {
    if (_isInit) return;
    _nomCtrl.text = c.nom;
    _telephoneCtrl.text = c.telephone ?? '';
    _adresseCtrl.text = c.descriptionAdresse ?? '';
    _horairesCtrl.text = c.horaires ?? '';
    _categorie = c.categorie;
    _isInit = true;
  }

  Future<void> _sauvegarder(CommerceEntity original) async {
    if (!_formKey.currentState!.validate()) return;
    if (_categorie == null) { _snack('Veuillez sélectionner une catégorie.', error: true); return; }
    setState(() => _isLoading = true);
    try {
      final updated = CommerceEntity(
        id: original.id, userId: original.userId,
        nom: _nomCtrl.text.trim(), categorie: _categorie!,
        telephone: _telephoneCtrl.text.trim(),
        descriptionAdresse: _adresseCtrl.text.trim(),
        latitude: original.latitude, longitude: original.longitude,
        horaires: _horairesCtrl.text.trim(),
        photos: original.photos, estPublie: original.estPublie,
        noteMoyenne: original.noteMoyenne, nombreAvis: original.nombreAvis,
        createdAt: original.createdAt,
      );
      await ref.read(updateCommerceUsecaseProvider).call(commerce: updated);
      setState(() => _isLoading = false);
      _snack('Commerce modifié avec succès !');
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
    final commerceAsync = ref.watch(commerceDetailProvider(widget.commerceId));

    return Scaffold(
      backgroundColor: AppTheme.neutralSand,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceContainerLow,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppTheme.primary),
          onPressed: () => context.pop(),
        ),
        title: Row(children: [
          Container(width: 32, height: 32, decoration: BoxDecoration(color: AppTheme.primaryContainer, borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.handyman_rounded, color: AppTheme.onPrimaryContainer, size: 18)),
          const SizedBox(width: 10),
          const Text('Artisan Core', style: TextStyle(fontFamily: 'Hanken Grotesk', fontWeight: FontWeight.w700, color: AppTheme.primary, fontSize: 18)),
        ]),
        actions: [
          IconButton(icon: const Icon(Icons.notifications_outlined, color: AppTheme.primary), onPressed: () {}),
        ],
      ),
      body: commerceAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.primary)),
        error: (e, _) => Center(child: Text('Erreur : $e')),
        data: (commerce) {
          _initFromCommerce(commerce);
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Modifier le commerce', style: TextStyle(fontFamily: 'Hanken Grotesk', fontSize: 26, fontWeight: FontWeight.w700, color: AppTheme.primary)),
                  const SizedBox(height: 4),
                  const Text('Mettez à jour vos informations pour rester visible auprès de vos clients.', style: TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 14, height: 1.4)),
                  const SizedBox(height: 24),

                  // Section Infos générales
                  _buildSection(
                    icon: Icons.store_rounded,
                    title: 'Informations Générales',
                    children: [
                      _buildField(label: 'Nom de l\'entreprise', icon: Icons.badge_outlined, child:
                        TextFormField(controller: _nomCtrl, validator: Validators.nom,
                          decoration: const InputDecoration(hintText: 'Ex: Menuiserie du Sahel'))),
                      const SizedBox(height: 14),
                      _buildField(label: 'Catégorie', icon: Icons.category_rounded, child:
                        DropdownButtonFormField<String>(
                          value: _categorie,
                          hint: const Text('Sélectionnez un métier'),
                          items: AppConstants.categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                          onChanged: (v) => setState(() => _categorie = v),
                          decoration: const InputDecoration(),
                        )),
                      const SizedBox(height: 14),
                      _buildField(label: 'Description des services', icon: Icons.description_outlined, child:
                        TextFormField(controller: _descriptionCtrl, maxLines: 3,
                          decoration: const InputDecoration(hintText: 'Décrivez vos services...'))),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Section Photos
                  _buildSection(
                    icon: Icons.image_rounded,
                    title: 'Photos du commerce',
                    children: [
                      if (commerce.photos.isNotEmpty) ...[
                        SizedBox(
                          height: 120,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: commerce.photos.length + 1,
                            separatorBuilder: (_, __) => const SizedBox(width: 10),
                            itemBuilder: (context, i) {
                              if (i == commerce.photos.length) return _addPhotoBtn();
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Stack(children: [
                                  Image.network(commerce.photos[i], width: 120, height: 120, fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(width: 120, height: 120, color: AppTheme.surfaceContainerHighest,
                                      child: const Icon(Icons.broken_image_outlined, color: AppTheme.outlineVariant))),
                                  Positioned(top: 6, right: 6,
                                    child: Container(
                                      decoration: BoxDecoration(color: AppTheme.error.withOpacity(0.9), borderRadius: BorderRadius.circular(999)),
                                      child: const Icon(Icons.close_rounded, color: Colors.white, size: 16),
                                    )),
                                ]),
                              );
                            },
                          ),
                        ),
                      ] else
                        _addPhotoBtn(full: true),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Section Localisation
                  _buildSection(
                    icon: Icons.location_on_rounded,
                    title: 'Localisation & Contact',
                    children: [
                      _buildField(label: 'Adresse', icon: Icons.map_outlined, child:
                        TextFormField(controller: _adresseCtrl, maxLines: 2,
                          validator: (v) => v!.isEmpty ? 'Requis' : null,
                          decoration: const InputDecoration(hintText: 'Ex: Avenue de la Liberté, Zone 1'))),
                      const SizedBox(height: 14),
                      // Minimap placeholder
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Stack(children: [
                          Image.network(
                            'https://maps.googleapis.com/maps/api/staticmap?center=Ouagadougou&zoom=13&size=400x160&key=',
                            height: 140, width: double.infinity, fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              height: 140, width: double.infinity,
                              decoration: BoxDecoration(color: AppTheme.surfaceContainerHigh, borderRadius: BorderRadius.circular(12)),
                              child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                Icon(Icons.map_rounded, size: 40, color: AppTheme.primary),
                                SizedBox(height: 8),
                                Text('Position GPS enregistrée', style: TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 13)),
                              ]),
                            ),
                          ),
                          Positioned(bottom: 8, right: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(color: AppTheme.surfaceContainerLowest.withOpacity(0.9), borderRadius: BorderRadius.circular(8)),
                              child: const Text('Ouagadougou', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                            )),
                        ]),
                      ),
                      const SizedBox(height: 14),
                      _buildField(label: 'Téléphone', icon: Icons.call_rounded, child:
                        TextFormField(controller: _telephoneCtrl, keyboardType: TextInputType.phone,
                          validator: Validators.telephone,
                          decoration: const InputDecoration(hintText: '+226 70 00 00 00'))),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Section Horaires
                  _buildSection(
                    icon: Icons.schedule_rounded,
                    title: 'Horaires d\'ouverture',
                    children: [
                      _buildField(label: 'Horaires', icon: Icons.access_time_rounded, child:
                        TextFormField(controller: _horairesCtrl,
                          decoration: const InputDecoration(hintText: 'Ex: Lun-Sam 08:00-18:00'))),
                      const SizedBox(height: 8),
                      const Text('Ex: Lun-Ven 08:00-18:00, Sam 09:00-14:00', style: TextStyle(fontSize: 12, color: AppTheme.onSurfaceVariant, fontStyle: FontStyle.italic)),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // Boutons
                  SizedBox(
                    width: double.infinity, height: 56,
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : () => _sauvegarder(commerce),
                      icon: _isLoading
                          ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: AppTheme.onPrimary, strokeWidth: 2))
                          : const Icon(Icons.check_circle_rounded),
                      label: Text(_isLoading ? 'Enregistrement...' : 'Enregistrer les modifications',
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity, height: 52,
                    child: OutlinedButton(
                      onPressed: () => context.pop(),
                      style: OutlinedButton.styleFrom(side: const BorderSide(color: AppTheme.outlineVariant)),
                      child: const Text('Annuler', style: TextStyle(color: AppTheme.onSurfaceVariant, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildSection({required IconData icon, required String title, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.outlineVariant.withOpacity(0.3)),
        boxShadow: [BoxShadow(color: AppTheme.primary.withOpacity(0.04), blurRadius: 12)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(icon, size: 20, color: AppTheme.primary),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontFamily: 'Hanken Grotesk', fontSize: 17, fontWeight: FontWeight.w600, color: AppTheme.primary)),
        ]),
        const SizedBox(height: 16),
        ...children,
      ]),
    );
  }

  Widget _buildField({required String label, required IconData icon, required Widget child}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Icon(icon, size: 16, color: AppTheme.onSurfaceVariant),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.onSurface)),
      ]),
      const SizedBox(height: 6),
      child,
    ]);
  }

  Widget _addPhotoBtn({bool full = false}) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: full ? double.infinity : 120,
        height: full ? 100 : 120,
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.primary.withOpacity(0.3), width: 2, style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(12),
          color: AppTheme.primary.withOpacity(0.04),
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.add_a_photo_rounded, size: 28, color: AppTheme.primary.withOpacity(0.7)),
          const SizedBox(height: 6),
          Text('Ajouter', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.primary.withOpacity(0.7))),
        ]),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border(top: BorderSide(color: AppTheme.outlineVariant.withOpacity(0.5))),
        boxShadow: [BoxShadow(color: AppTheme.primary.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, -4))],
      ),
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 20),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        _navItem(Icons.dashboard_rounded, 'Dashboard', false, () => context.go('/artisan/dashboard')),
        _navItem(Icons.add_circle_outline_rounded, 'Ajouter', true, () => context.push('/artisan/creer')),
        _navItem(Icons.inventory_2_outlined, 'Mes Offres', false, () {}),
        _navItem(Icons.visibility_outlined, 'Visibilité', false, () {}),
      ]),
    );
  }

  Widget _navItem(IconData icon, String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: active ? AppTheme.primaryContainer.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, color: active ? AppTheme.primary : AppTheme.onSurfaceVariant, size: 22),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: active ? AppTheme.primary : AppTheme.onSurfaceVariant)),
        ]),
      ),
    );
  }
}
