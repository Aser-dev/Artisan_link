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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: const Color(0xFF1E1E1E),
        title: const Text('Détail', style: TextStyle(color: Color(0xFF1E1E1E))),
        actions: [
          IconButton(icon: const Icon(Icons.share_outlined), onPressed: () {}),
        ],
      ),
      body: commerceAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Erreur : $err')),
        data: (commerce) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(16),
                    image: commerce.photos.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(commerce.photos.first),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: commerce.photos.isEmpty
                      ? const Icon(
                          Icons.storefront,
                          size: 60,
                          color: Colors.grey,
                        )
                      : null,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F3F5),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        commerce.categorie,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: commerce.estPublie
                            ? Colors.green[100]
                            : Colors.red[100],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        commerce.estPublie ? 'Ouvert' : 'Fermé',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: commerce.estPublie
                              ? Colors.green[700]
                              : Colors.red[700],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  commerce.nom,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Par ${commerce.userId}',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                if (commerce.horaires != null) ...[
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 18,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      Text(commerce.horaires!),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 18,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        commerce.descriptionAdresse ?? 'Adresse non renseignée',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    RatingStars(rating: commerce.noteMoyenne, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      '${commerce.noteMoyenne.toStringAsFixed(1)} (${commerce.nombreAvis} avis)',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                const Divider(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _appeler(commerce.telephone),
                        icon: const Icon(Icons.phone),
                        label: const Text('Appeler'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8CD82C),
                          foregroundColor: const Color(0xFF1E1E1E),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _partagerWhatsApp(commerce),
                        icon: const Icon(Icons.share),
                        label: const Text('Partager'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: const BorderSide(color: Color(0xFF8CD82C)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'Avis des clients',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DonnerAvisPage(commerceId: commerce.id),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Donner mon avis'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E1E1E),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                avisAsync.when(
                  loading: () => const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  error: (err, stack) =>
                      const Text('Impossible de charger les avis.'),
                  data: (avis) => ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: avis.length,
                    itemBuilder: (context, index) {
                      final a = avis[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: const Color(0xFFF1F3F5),
                            child: Text(
                              a.auteurNom.isNotEmpty
                                  ? a.auteurNom[0].toUpperCase()
                                  : '?',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(a.commentaire),
                          subtitle: Row(
                            children: [
                              RatingStars(
                                rating: a.noteIa.toDouble(),
                                size: 14,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${a.noteIa}/5 • ${_dateFormat(a.createdAt)}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  void _appeler(String? phone) async {
    if (phone == null) return;
    final uri = Uri.parse('tel:${phone.replaceAll(' ', '')}');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  void _partagerWhatsApp(commerce) async {
    final message =
        '🛠️ ArtisanBF\n\n'
        'Nom : ${commerce.nom}\n'
        'Catégorie : ${commerce.categorie}\n'
        'Téléphone : ${commerce.telephone ?? 'Non renseigné'}\n'
        'Adresse : ${commerce.descriptionAdresse ?? 'Non renseignée'}';
    final uri = Uri.parse(
      'https://wa.me/?text=${Uri.encodeComponent(message)}',
    );
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  String _dateFormat(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0) return "Aujourd'hui";
    if (diff.inDays == 1) return "Hier";
    if (diff.inDays < 7) return "Il y a ${diff.inDays} jours";
    return "${date.day}/${date.month}/${date.year}";
  }
}
