// lib/presentation/pages/citoyen/detail_commerce_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../providers/commerce_provider.dart';
import '../../providers/avis_provider.dart';
import '../../widgets/rating_stars.dart';
import 'donner_avis_page.dart';

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
      backgroundColor: const Color(0xFFF8F9FA),
      body: commerceAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFF8CD82C))),
        error: (err, _) => Center(child: Text('Erreur : $err')),
        data: (commerce) => CustomScrollView(
          slivers: [
            // Image avec AppBar transparent
            SliverAppBar(
              expandedHeight: 240,
              pinned: true,
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF1E1E1E),
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                background: commerce.photos.isNotEmpty
                    ? Image.network(commerce.photos.first, fit: BoxFit.cover)
                    : Container(
                        color: const Color(0xFFF1F3F5),
                        child: const Center(
                          child: Icon(Icons.storefront_rounded, size: 72, color: Color(0xFFCED4DA)),
                        ),
                      ),
              ),
              actions: [
                Container(
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), borderRadius: BorderRadius.circular(10)),
                  child: IconButton(
                    icon: const Icon(Icons.share_outlined, size: 20),
                    onPressed: () => _partagerWhatsApp(commerce),
                  ),
                ),
              ],
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Badges
                    Row(
                      children: [
                        _Badge(label: commerce.categorie, color: const Color(0xFF2E4A0B), bg: const Color(0xFFE8F5E9)),
                        const SizedBox(width: 8),
                        _Badge(
                          label: commerce.estPublie ? 'Ouvert' : 'Fermé',
                          color: commerce.estPublie ? Colors.green[700]! : Colors.red[700]!,
                          bg: commerce.estPublie ? Colors.green[50]! : Colors.red[50]!,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(commerce.nom, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF1E1E1E))),
                    const SizedBox(height: 8),
                    // Note
                    Row(
                      children: [
                        RatingStars(rating: commerce.noteMoyenne, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          '${commerce.noteMoyenne.toStringAsFixed(1)} · ${commerce.nombreAvis} avis',
                          style: const TextStyle(color: Color(0xFF6C757D), fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Infos
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE9ECEF)),
                      ),
                      child: Column(
                        children: [
                          if (commerce.horaires != null)
                            _InfoRow(icon: Icons.access_time_rounded, text: commerce.horaires!),
                          if (commerce.horaires != null) const SizedBox(height: 10),
                          _InfoRow(
                            icon: Icons.location_on_outlined,
                            text: commerce.descriptionAdresse ?? 'Adresse non renseignée',
                          ),
                          if (commerce.telephone != null) ...[
                            const SizedBox(height: 10),
                            _InfoRow(icon: Icons.phone_outlined, text: commerce.telephone!),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Boutons d'action
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _appeler(commerce.telephone),
                            icon: const Icon(Icons.phone_rounded, size: 18),
                            label: const Text('Appeler', style: TextStyle(fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF8CD82C),
                              foregroundColor: const Color(0xFF1E1E1E),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _partagerWhatsApp(commerce),
                            icon: const Icon(Icons.share_rounded, size: 18),
                            label: const Text('Partager', style: TextStyle(fontWeight: FontWeight.bold)),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF2E4A0B),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              side: const BorderSide(color: Color(0xFF8CD82C), width: 1.5),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Section avis
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Avis clients', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        GestureDetector(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DonnerAvisPage(commerceId: commerce.id))),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E1E1E),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.edit_rounded, size: 14, color: Colors.white),
                                SizedBox(width: 6),
                                Text('Avis', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    avisAsync.when(
                      loading: () => const Center(child: Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator())),
                      error: (_, __) => const Text('Impossible de charger les avis.'),
                      data: (avis) => avis.isEmpty
                          ? Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: const Color(0xFFE9ECEF)),
                              ),
                              child: const Center(
                                child: Text('Aucun avis pour l\'instant.', style: TextStyle(color: Colors.grey)),
                              ),
                            )
                          : Column(
                              children: avis.map((a) => Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: const Color(0xFFE9ECEF)),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundColor: const Color(0xFFF1F3F5),
                                      child: Text(
                                        a.auteurNom.isNotEmpty ? a.auteurNom[0].toUpperCase() : '?',
                                        style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2E4A0B)),
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
                                              Text(a.auteurNom, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                              Text(_dateFormat(a.createdAt), style: const TextStyle(fontSize: 11, color: Colors.grey)),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          RatingStars(rating: a.noteIa.toDouble(), size: 13),
                                          const SizedBox(height: 4),
                                          Text(a.commentaire, style: const TextStyle(fontSize: 13, color: Color(0xFF495057), height: 1.4)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
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

  void _appeler(String? phone) async {
    if (phone == null) return;
    final uri = Uri.parse('tel:${phone.replaceAll(' ', '')}');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  void _partagerWhatsApp(commerce) async {
    final message = '🛠️ ArtisanBF\n\nNom : ${commerce.nom}\nCatégorie : ${commerce.categorie}\nTéléphone : ${commerce.telephone ?? 'Non renseigné'}\nAdresse : ${commerce.descriptionAdresse ?? 'Non renseignée'}';
    final uri = Uri.parse('https://wa.me/?text=${Uri.encodeComponent(message)}');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  String _dateFormat(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays == 0) return "Aujourd'hui";
    if (diff.inDays == 1) return "Hier";
    if (diff.inDays < 7) return "Il y a ${diff.inDays}j";
    return "${date.day}/${date.month}/${date.year}";
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  final Color bg;
  const _Badge({required this.label, required this.color, required this.bg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: color)),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: const Color(0xFF8CD82C)),
        const SizedBox(width: 10),
        Expanded(child: Text(text, style: const TextStyle(color: Color(0xFF495057)))),
      ],
    );
  }
}
