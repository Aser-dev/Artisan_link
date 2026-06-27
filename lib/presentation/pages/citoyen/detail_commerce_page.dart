// lib/presentation/pages/citoyen/detail_commerce_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../providers/commerce_provider.dart';
import '../../providers/avis_provider.dart';
import '../../widgets/rating_stars.dart';
import '../../../core/theme/app_theme.dart';
import 'donner_avis_page.dart';
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
      backgroundColor: AppTheme.neutralSand,
      body: commerceAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.primary)),
        error: (e, _) => Center(child: Text('Erreur : $e')),
        data: (commerce) => CustomScrollView(
          slivers: [
            // SliverAppBar avec image
            SliverAppBar(
              expandedHeight: 260,
              pinned: true,
              backgroundColor: AppTheme.surfaceContainerLow,
              foregroundColor: AppTheme.onSurface,
              elevation: 0,
              leading: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: AppTheme.surfaceContainerLowest.withValues(alpha: 0.9), borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.arrow_back_rounded, color: AppTheme.onSurface, size: 20),
                ),
              ),
              actions: [
                GestureDetector(
                  onTap: () => _partagerWhatsApp(commerce),
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: AppTheme.surfaceContainerLowest.withValues(alpha: 0.9), borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.share_rounded, color: AppTheme.onSurface, size: 20),
                  ),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: commerce.photos.isNotEmpty
                    ? Image.network(commerce.photos.first, fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => _bannerPlaceholder(commerce.categorie))
                    : _bannerPlaceholder(commerce.categorie),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Badges
                    Row(children: [
                      _Badge(label: commerce.categorie, color: AppTheme.terracottaClay, bg: AppTheme.terracottaClay.withValues(alpha: 0.1)),
                      const SizedBox(width: 8),
                      _Badge(
                        label: commerce.estPublie ? 'Ouvert' : 'Fermé',
                        color: commerce.estPublie ? AppTheme.primaryContainer : AppTheme.error,
                        bg: commerce.estPublie ? AppTheme.primaryContainer.withValues(alpha: 0.1) : AppTheme.errorContainer,
                        dot: true,
                      ),
                    ]),
                    const SizedBox(height: 12),

                    // Nom
                    Text(commerce.nom, style: const TextStyle(fontFamily: 'Hanken Grotesk', fontSize: 26, fontWeight: FontWeight.w700, color: AppTheme.onSurface)),
                    const SizedBox(height: 8),

                    // Note
                    Row(children: [
                      RatingStars(rating: commerce.noteMoyenne, size: 18),
                      const SizedBox(width: 8),
                      Text('${commerce.noteMoyenne.toStringAsFixed(1)} · ${commerce.nombreAvis} avis',
                        style: const TextStyle(color: AppTheme.onSurfaceVariant, fontWeight: FontWeight.w500, fontSize: 14)),
                    ]),
                    const SizedBox(height: 16),

                    // Infos card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.outlineVariant.withValues(alpha: 0.3)),
                        boxShadow: [BoxShadow(color: AppTheme.primary.withValues(alpha: 0.04), blurRadius: 12)],
                      ),
                      child: Column(children: [
                        if (commerce.horaires != null) ...[
                          _InfoRow(icon: Icons.access_time_rounded, text: commerce.horaires!),
                          const SizedBox(height: 10),
                        ],
                        _InfoRow(icon: Icons.location_on_rounded, text: commerce.descriptionAdresse ?? 'Adresse non renseignée'),
                        if (commerce.telephone != null) ...[
                          const SizedBox(height: 10),
                          _InfoRow(icon: Icons.phone_rounded, text: commerce.telephone!),
                        ],
                      ]),
                    ),
                    const SizedBox(height: 16),

                    // Boutons action
                    Row(children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _appeler(commerce.telephone),
                          icon: const Icon(Icons.phone_rounded, size: 18),
                          label: const Text('Appeler', style: TextStyle(fontWeight: FontWeight.w700)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primary,
                            foregroundColor: AppTheme.onPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            minimumSize: Size.zero,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _partagerWhatsApp(commerce),
                          icon: const Icon(Icons.share_rounded, size: 18),
                          label: const Text('Partager', style: TextStyle(fontWeight: FontWeight.w700)),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.primary,
                            side: const BorderSide(color: AppTheme.primary),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            minimumSize: Size.zero,
                          ),
                        ),
                      ),
                    ]),
                    const SizedBox(height: 24),

                    // Section galerie si photos multiples
                    if (commerce.photos.length > 1) ...[
                      const Text('Photos', style: TextStyle(fontFamily: 'Hanken Grotesk', fontSize: 18, fontWeight: FontWeight.w600, color: AppTheme.onSurface)),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 100,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: commerce.photos.length,
                          separatorBuilder: (_) => const SizedBox(width: 8),
                          itemBuilder: (_, i) => ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(commerce.photos[i], width: 100, height: 100, fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => Container(width: 100, height: 100, color: AppTheme.surfaceContainerHighest)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Section avis
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      const Text('Avis clients', style: TextStyle(fontFamily: 'Hanken Grotesk', fontSize: 18, fontWeight: FontWeight.w600, color: AppTheme.onSurface)),
                      GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DonnerAvisPage(commerceId: commerce.id))),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(999)),
                          child: const Row(children: [
                            Icon(Icons.edit_rounded, size: 14, color: AppTheme.onPrimary),
                            SizedBox(width: 6),
                            Text('Donner mon avis', style: TextStyle(color: AppTheme.onPrimary, fontWeight: FontWeight.w600, fontSize: 12)),
                          ]),
                        ),
                      ),
                    ]),
                    const SizedBox(height: 12),

                    avisAsync.when(
                      loading: () => const Center(child: Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator(color: AppTheme.primary))),
                      error: (_) => const Text('Impossible de charger les avis.'),
                      data: (avis) => avis.isEmpty
                          ? Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(color: AppTheme.surfaceContainerLowest, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppTheme.outlineVariant.withValues(alpha: 0.3))),
                              child: const Center(child: Text('Aucun avis pour l\'instant.', style: TextStyle(color: AppTheme.onSurfaceVariant))))
                          : Column(
                              children: avis.map((a) => Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: AppTheme.surfaceContainerLowest,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: AppTheme.outlineVariant.withValues(alpha: 0.3)),
                                  boxShadow: [BoxShadow(color: AppTheme.primary.withValues(alpha: 0.03), blurRadius: 8)],
                                ),
                                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Container(
                                    width: 40, height: 40,
                                    decoration: BoxDecoration(color: AppTheme.primaryContainer.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(999)),
                                    child: Center(child: Text(
                                      a.auteurNom.isNotEmpty ? a.auteurNom[0].toUpperCase() : '?',
                                      style: const TextStyle(fontWeight: FontWeight.w700, color: AppTheme.primaryContainer, fontSize: 16),
                                    )),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                      Text(a.auteurNom, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppTheme.onSurface)),
                                      Text(_dateFormat(a.createdAt), style: const TextStyle(fontSize: 11, color: AppTheme.onSurfaceVariant)),
                                    ]),
                                    const SizedBox(height: 4),
                                    RatingStars(rating: a.noteIa.toDouble(), size: 13),
                                    const SizedBox(height: 6),
                                    Text(a.commentaire, style: const TextStyle(fontSize: 13, color: AppTheme.onSurfaceVariant, height: 1.4)),
                                    // Badge IA
                                    const SizedBox(height: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(color: AppTheme.terracottaClay.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                                        const Icon(Icons.auto_awesome_rounded, size: 11, color: AppTheme.terracottaClay),
                                        const SizedBox(width: 4),
                                        Text('Note IA : ${a.noteIa}/5', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.terracottaClay)),
                                      ]),
                                    ),
                                  ])),
                                ]),
                              )).toList(),
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

  Widget _bannerPlaceholder(String categorie) {
    return Container(
      color: AppTheme.surfaceContainerHigh,
      child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(_getIcon(categorie), size: 64, color: AppTheme.outlineVariant),
      ])),
    );
  }

  IconData _getIcon(String cat) {
    switch (cat.toLowerCase()) {
      case 'mécanicien': return Icons.build_rounded;
      case 'couturier': return Icons.checkroom_rounded;
      case 'coiffeur': return Icons.content_cut_rounded;
      case 'soudeur': return Icons.hardware_rounded;
      case 'électricien': return Icons.electrical_services_rounded;
      default: return Icons.storefront_rounded;
    }
  }

  void _appeler(String? phone) async {
    if (phone == null) return;
    final uri = Uri.parse('tel:${phone.replaceAll(' ', '')}');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  void _partagerWhatsApp(CommerceEntity commerce) async {
    final msg = '🛠️ Artisan Core\n\nNom : ${commerce.nom}\nCatégorie : ${commerce.categorie}\nTél : ${commerce.telephone ?? '-'}\nAdresse : ${commerce.descriptionAdresse ?? '-'}';
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

class _Badge extends StatelessWidget {
  final String label;
  final Color color, bg;
  final bool dot;
  const _Badge({required this.label, required this.color, required this.bg, this.dot = false});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
    decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      if (dot) ...[Container(width: 6, height: 6, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(999))), const SizedBox(width: 6)],
      Text(label, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: color)),
    ]),
  );
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) => Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Icon(icon, size: 17, color: AppTheme.primary),
    const SizedBox(width: 10),
    Expanded(child: Text(text, style: const TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 14, height: 1.4))),
  ]);
}




