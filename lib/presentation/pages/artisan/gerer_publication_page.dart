// lib/presentation/pages/artisan/gerer_publication_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/commerce_provider.dart';
import '../../providers/auth_provider.dart';
import '../../../core/di/injection_container.dart';

class GererPublicationPage extends ConsumerStatefulWidget {
  final String commerceId;
  final bool estPublieActuel;

  const GererPublicationPage({
    super.key,
    required this.commerceId,
    required this.estPublieActuel,
  });

  @override
  ConsumerState<GererPublicationPage> createState() =>
      _GererPublicationPageState();
}

class _GererPublicationPageState extends ConsumerState<GererPublicationPage> {
  late bool _estPublie;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _estPublie = widget.estPublieActuel;
  }

  Future<void> _sauvegarder() async {
    setState(() => _isLoading = true);
    try {
      await ref
          .read(togglePublicationUsecaseProvider)
          .call(commerceId: widget.commerceId, publier: _estPublie);
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _estPublie
                ? '✅ Commerce publié !'
                : '🔒 Commerce retiré de l\'annuaire.',
          ),
          backgroundColor: _estPublie ? Colors.green : Colors.orange,
        ),
      );
      context.pop();
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('❌ Erreur : ${e.toString()}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        title: const Text(
          'Gérer la publication',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        foregroundColor: const Color(0xFF1E1E1E),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE9ECEF)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Visibilité de votre commerce',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Card(
                          color: _estPublie
                              ? Colors.green[50]
                              : Colors.grey[100],
                          child: SwitchListTile(
                            title: Text(
                              _estPublie ? '✅ Publié' : '❌ Brouillon',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _estPublie
                                    ? Colors.green[700]
                                    : Colors.grey,
                              ),
                            ),
                            subtitle: Text(
                              _estPublie
                                  ? 'Visible par les citoyens'
                                  : 'Non visible dans l\'annuaire',
                              style: const TextStyle(fontSize: 12),
                            ),
                            value: _estPublie,
                            onChanged: _isLoading
                                ? null
                                : (value) => setState(() => _estPublie = value),
                            activeColor: const Color(0xFF8CD82C),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '💡 Les commerces publiés apparaissent sur la carte et dans la liste des citoyens.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _sauvegarder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8CD82C),
                  foregroundColor: const Color(0xFF1E1E1E),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(
                        color: Color(0xFF1E1E1E),
                        strokeWidth: 2,
                      )
                    : const Text(
                        'Enregistrer',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
