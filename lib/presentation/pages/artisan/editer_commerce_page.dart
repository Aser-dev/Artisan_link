// lib/presentation/pages/artisan/editer_commerce_page.dart
// Modification d'un commerce existant avec formulaire pré-rempli
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/commerce_provider.dart';
import '../../../core/di/injection_container.dart';
import '../../../domain/entities/commerce_entity.dart';
import '../../../core/constants.dart';
import '../../../core/utils/validators.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/design_system.dart';
import '../../widgets/skeletons.dart';

class EditerCommercePage extends ConsumerStatefulWidget {
  final String commerceId;
  const EditerCommercePage({super.key, required this.commerceId});

  @override
  ConsumerState<EditerCommercePage> createState() =>
      _EditerCommercePageState();
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
    _nomCtrl.dispose();
    _telephoneCtrl.dispose();
    _adresseCtrl.dispose();
    _horairesCtrl.dispose();
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
    if (_categorie == null) {
      _snack('Veuillez sélectionner une catégorie.', error: true);
      return;
    }
    HapticFeedback.lightImpact();
    setState(() => _isLoading = true);
    try {
      final updated = CommerceEntity(
        id: original.id,
        userId: original.userId,
        nom: _nomCtrl.text.trim(),
        categorie: _categorie!,
        telephone: _telephoneCtrl.text.trim(),
        descriptionAdresse: _adresseCtrl.text.trim(),
        latitude: original.latitude,
        longitude: original.longitude,
        horaires: _horairesCtrl.text.trim(),
        photos: original.photos,
        estPublie: original.estPublie,
        noteMoyenne: original.noteMoyenne,
        nombreAvis: original.nombreAvis,
        createdAt: original.createdAt,
      );
      await ref.read(updateCommerceUsecaseProvider).call(commerce: updated);
      if (!mounted) return;
      setState(() => _isLoading = false);
      _snack('Commerce modifié avec succès !');
      context.pop();
    } catch (e) {
      if (!mounted) return;
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
    final commerceAsync =
        ref.watch(commerceDetailProvider(widget.commerceId));

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
      body: commerceAsync.when(
        loading: () => const SkeletonDetail(),
        error: (e, _) => Center(
                child: Text('Erreur : $e',
                    style: GoogleFonts.inter(
                        color: AppTheme.texteSecondaire))),
        data: (commerce) {
          _initFromCommerce(commerce);
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Modifier le commerce',
                    style: GoogleFonts.inter(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textePrimaire,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Mettez à jour vos informations.',
                    style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppTheme.texteSecondaire),
                  ),
                  const SizedBox(height: 24),

                  FormSection(
                    icon: Icons.store_rounded,
                    title: 'Informations Générales',
                    children: [
                      AppInput(
                        label: "Nom de l'entreprise",
                        hint: 'Ex: Menuiserie du Sahel',
                        icon: Icons.badge_outlined,
                        controller: _nomCtrl,
                        validator: Validators.nom,
                      ),
                      const SizedBox(height: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Catégorie',
                              style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.texteSecondaire)),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            value: _categorie,
                            hint: const Text('Sélectionnez un métier'),
                            dropdownColor: AppTheme.surfaceCard,
                            style: GoogleFonts.inter(
                                fontSize: 14,
                                color: AppTheme.textePrimaire),
                            items: AppConstants.categories
                                .map((c) => DropdownMenuItem(
                                    value: c, child: Text(c)))
                                .toList(),
                            onChanged: (v) =>
                                setState(() => _categorie = v),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: AppTheme.surfaceCard,
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(14),
                                borderSide: const BorderSide(
                                    color: AppTheme.bordureSubtile),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      AppInput(
                        label: 'Description des services',
                        hint: 'Décrivez vos services...',
                        icon: Icons.description_outlined,
                        controller: _descriptionCtrl,
                        maxLines: 3,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  FormSection(
                    icon: Icons.image_rounded,
                    title: 'Photos du commerce',
                    children: [
                      if (commerce.photos.isNotEmpty)
                        SizedBox(
                          height: 120,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: commerce.photos.length + 1,
                            separatorBuilder: (_, _) =>
                                const SizedBox(width: 10),
                            itemBuilder: (ctx, i) {
                              if (i == commerce.photos.length) {
                                return _addPhotoBtn();
                              }
                              return ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(12),
                                child: Image.network(
                                    commerce.photos[i],
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, _, _) =>
                                        Container(
                                          width: 120,
                                          height: 120,
                                          color: AppTheme
                                              .surfaceCardHover,
                                        )),
                              );
                            },
                          ),
                        )
                      else
                        _addPhotoBtn(full: true),
                    ],
                  ),
                  const SizedBox(height: 16),

                  FormSection(
                    icon: Icons.location_on_rounded,
                    title: 'Localisation & Contact',
                    children: [
                      AppInput(
                        label: 'Adresse',
                        hint: 'Ex: Avenue de la Liberté, Zone 1',
                        icon: Icons.map_outlined,
                        controller: _adresseCtrl,
                        maxLines: 2,
                        validator: (v) =>
                            v!.isEmpty ? 'Requis' : null,
                      ),
                      const SizedBox(height: 14),
                      Container(
                        height: 100,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceCardHover,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.map_rounded,
                                size: 32,
                                color: AppTheme.accentPrimaire),
                            const SizedBox(height: 8),
                            Text(
                              'Position GPS enregistrée',
                              style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: AppTheme.texteSecondaire),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      AppInput(
                        label: 'Téléphone',
                        hint: '+226 70 00 00 00',
                        icon: Icons.call_rounded,
                        controller: _telephoneCtrl,
                        validator: Validators.telephone,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  FormSection(
                    icon: Icons.schedule_rounded,
                    title: "Horaires d'ouverture",
                    children: [
                      AppInput(
                        label: 'Horaires',
                        hint: 'Ex: Lun-Sam 08:00-18:00',
                        icon: Icons.access_time_rounded,
                        controller: _horairesCtrl,
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  PrimaryButton(
                    label: 'Enregistrer les modifications',
                    isLoading: _isLoading,
                    onPressed: () => _sauvegarder(commerce),
                    icon: Icons.check_circle_rounded,
                  ),
                  const SizedBox(height: 12),
                  SecondaryButton(
                    label: 'Annuler',
                    onPressed: () => context.pop(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _addPhotoBtn({bool full = false}) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: full ? double.infinity : 120,
        height: full ? 100 : 120,
        decoration: BoxDecoration(
          border: Border.all(
              color: AppTheme.accentPrimaire.withValues(alpha: 0.3),
              width: 2),
          borderRadius: BorderRadius.circular(12),
          color: AppTheme.accentSecondaire.withValues(alpha: 0.05),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_a_photo_rounded,
                size: 28,
                color:
                    AppTheme.accentPrimaire.withValues(alpha: 0.7)),
            const SizedBox(height: 6),
            Text(
              'Ajouter',
              style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color:
                      AppTheme.accentPrimaire.withValues(alpha: 0.7)),
            ),
          ],
        ),
      ),
    );
  }
}