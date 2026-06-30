// lib/presentation/pages/citoyen/detail_commerce_page.dart
// Page détaillée d'un commerce avec photos, infos, avis et partage WhatsApp
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/commerce_provider.dart';
import '../../providers/avis_provider.dart';
import '../../widgets/design_system.dart';
import '../../widgets/skeletons.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/commerce_entity.dart';

class DetailCommercePage extends ConsumerStatefulWidget {
  final String commerceId;
  const DetailCommercePage({super.key, required this.commerceId});

  @override
  ConsumerState<DetailCommercePage> createState() => _DetailCommercePageState();
}

class _DetailCommercePageState extends ConsumerState<DetailCommercePage> {
  @override
  void initState() {
    super.initState();
    ref.read(avisListProvider(widget.commerceId));
  }

  @override
  Widget build(BuildContext context) {
    final commerceAsync = ref.watch(commerceDetailProvider(widget.commerceId));
    final avisAsync = ref.watch(avisListProvider(widget.commerceId));

    return Scaffold(
      backgroundColor: AppTheme.fondPrincipal,
      body: commerceAsync.when(
        loading: () => const SkeletonDetail(),
        error: (e, _) => Center(
          child: EmptyState(
            icon: Icons.error_outline_rounded,
            title: 'Erreur de chargement',
            subtitle: 'Impossible de charger les informations du commerce.',
            actionLabel: 'Réessayer',
            onAction: () => ref.refresh(commerceDetailProvider(widget.commerceId)),
          ),
        ),
        data: (commerce) => CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 260,
              pinned: true,
              backgroundColor: AppTheme.fondPrincipal,
              foregroundColor: AppTheme.textePrimaire,
              elevation: 0,
              leading: GestureDetector(
                onTap: () => context.pop(),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceCard.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.bordureSubtile),
                  ),
                  child: const Icon(Icons.arrow_back_rounded,
                      color: AppTheme.textePrimaire, size: 20),
                ),
              ),
              actions: [
                GestureDetector(
                  onTap: () => _partagerWhatsApp(commerce),
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceCard.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.bordureSubtile),
                    ),
                    child: const Icon(Icons.share_rounded,
                        color: AppTheme.accentPrimaire, size: 20),
                  ),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: commerce.photos.isNotEmpty
                    ? Image.network(commerce.photos.first,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) =>
                            _bannerPlaceholder(commerce.categorie))
                    : _bannerPlaceholder(commerce.categorie),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      StatutBadge(
                        label: commerce.categorie,
                        actif: true,
                      ),
                      const SizedBox(width: 8),
                      StatutBadge(
                        label: commerce.estPublie ? 'Ouvert' : 'Fermé',
                        actif: commerce.estPublie,
                        couleurActive: AppTheme.accentPrimaire,
                        couleurInactive: AppTheme.erreur,
                      ),
                    ]),
                    const SizedBox(height: 12),
                    Text(
                      commerce.nom,
                      style: GoogleFonts.inter(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textePrimaire,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded,
                            size: 18, color: AppTheme.accentPrimaire),
                        const SizedBox(width: 6),
                        Text(
                          '${commerce.noteMoyenne.toStringAsFixed(1)} · ${commerce.nombreAvis} avis',
                          style: GoogleFonts.inter(
                            color: AppTheme.texteSecondaire,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Infos card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceCard,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppTheme.bordureSubtile),
                      ),
                      child: Column(
                        children: [
                          if (commerce.horaires != null) ...[
                            InfoRow(
                              icon: Icons.access_time_rounded,
                              text: commerce.horaires!,
                            ),
                            const SizedBox(height: 10),
                          ],
                          InfoRow(
                            icon: Icons.location_on_rounded,
                            text: commerce.descriptionAdresse ??
                                'Adresse non renseignée',
                          ),
                          if (commerce.telephone != null) ...[
                            const SizedBox(height: 10),
                            InfoRow(
                              icon: Icons.phone_rounded,
                              text: commerce.telephone!,
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Boutons action
                    Row(
                      children: [
                        Expanded(
                          child: PrimaryButton(
                            label: 'Appeler',
                            onPressed: () => _appeler(commerce.telephone),
                            icon: Icons.phone_rounded,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SecondaryButton(
                            label: 'Partager',
                            onPressed: () => _partagerWhatsApp(commerce),
                            icon: Icons.share_rounded,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Galerie
                    if (commerce.photos.length > 1) ...[
                      Text(
                        'Photos',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textePrimaire,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 100,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: commerce.photos.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(width: 8),
                          itemBuilder: (_, i) => ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              commerce.photos[i],
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => Container(
                                width: 100,
                                height: 100,
                                color: AppTheme.surfaceCardHover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Section avis
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Avis clients',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textePrimaire,
                          ),
                        ),
                        AppActionChip(
                          icon: Icons.edit_rounded,
                          label: 'Donner mon avis',
                          onTap: () {
                            HapticFeedback.lightImpact();
                            context.push(
                                '/donner-avis/${commerce.id}');
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    avisAsync.when(
                      loading: () => const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppTheme.accentPrimaire,
                          ),
                        ),
                      ),
                      error: (_, _) => const Text(
                        'Impossible de charger les avis.',
                        style: TextStyle(color: AppTheme.texteSecondaire),
                      ),
                      data: (avis) => avis.isEmpty
                          ? Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: AppTheme.surfaceCard,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                    color: AppTheme.bordureSubtile),
                              ),
                              child: Center(
                                child: Text(
                                  'Aucun avis pour l\'instant.',
                                  style: GoogleFonts.inter(
                                    color: AppTheme.texteSecondaire,
                                  ),
                                ),
                              ),
                            )
                          : Column(
                              children: avis
                                  .map((a) => _buildAvisCard(
                                      a.auteurNom,
                                      a.noteIa.toDouble(),
                                      a.commentaire,
                                      a.createdAt))
                                  .toList(),
                            ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvisCard(
      String nom, double note, String commentaire, DateTime date) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.bordureSubtile),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.accentSecondaire.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(99),
            ),
            child: Center(
              child: Text(
                nom.isNotEmpty ? nom[0].toUpperCase() : '?',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.accentPrimaire,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      nom,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: AppTheme.textePrimaire,
                      ),
                    ),
                    Text(
                      _dateFormat(date),
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppTheme.texteSecondaire,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    ...List.generate(5, (i) => Icon(
                      i < note.round()
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      size: 14,
                      color: AppTheme.accentPrimaire,
                    )),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  commentaire,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppTheme.texteSecondaire,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppTheme.accentSecondaire.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.auto_awesome_rounded,
                          size: 11, color: AppTheme.accentPrimaire),
                      const SizedBox(width: 4),
                      Text(
                        'Note IA : ${note.toInt()}/5',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.accentPrimaire,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bannerPlaceholder(String categorie) {
    return Container(
      color: AppTheme.surfaceCardHover,
      child: Center(
        child: Icon(
          _getIcon(categorie),
          size: 64,
          color: AppTheme.texteTertiaire,
        ),
      ),
    );
  }

  IconData _getIcon(String cat) {
    switch (cat.toLowerCase()) {
      case 'mécanicien':
        return Icons.build_rounded;
      case 'couturier':
        return Icons.checkroom_rounded;
      case 'coiffeur':
        return Icons.content_cut_rounded;
      case 'soudeur':
        return Icons.hardware_rounded;
      case 'électricien':
        return Icons.electrical_services_rounded;
      default:
        return Icons.storefront_rounded;
    }
  }

  void _appeler(String? phone) async {
    if (phone == null) return;
    final uri = Uri.parse('tel:${phone.replaceAll(' ', '')}');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  void _partagerWhatsApp(CommerceEntity commerce) async {
    final msg =
        '🛠️ Artisan BF\n\nNom : ${commerce.nom}\nCatégorie : ${commerce.categorie}\nTél : ${commerce.telephone ?? '-'}\nAdresse : ${commerce.descriptionAdresse ?? '-'}';
    final uri = Uri.parse('https://wa.me/?text=${Uri.encodeComponent(msg)}');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  String _dateFormat(DateTime d) {
    final diff = DateTime.now().difference(d);
    if (diff.inDays == 0) return "Aujourd'hui";
    if (diff.inDays == 1) return "Hier";
    if (diff.inDays < 7) return "Il y a ${diff.inDays}j";
    return "${d.day}/${d.month}/${d.year}";
  }
}