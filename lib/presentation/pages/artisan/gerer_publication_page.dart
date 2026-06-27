// lib/presentation/pages/artisan/gerer_publication_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/commerce_provider.dart';
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
  ConsumerState<GererPublicationPage> createState() => _GererPublicationPageState();
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
      await ref.read(togglePublicationUsecaseProvider).call(commerceId: widget.commerceId, publier: _estPublie);
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_estPublie ? '✅ Commerce publié !' : '🔒 Commerce retiré de l\'annuaire.'),
          backgroundColor: _estPublie ? Colors.green[700] : Colors.orange[700],
        ),
      );
      context.pop();
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('❌ Erreur : ${e.toString()}'), backgroundColor: Colors.red[700]));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        title: const Text('Gérer la publication', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        foregroundColor: const Color(0xFF1E1E1E),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE9ECEF)),
              ),
              child: Column(
                children: [
                  // Icône état
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: _estPublie ? Colors.green[50] : Colors.grey[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      _estPublie ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                      size: 36,
                      color: _estPublie ? Colors.green[700] : Colors.grey[500],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _estPublie ? 'Commerce visible' : 'Commerce masqué',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _estPublie
                        ? 'Votre commerce est visible sur la carte et dans la liste.'
                        : 'Votre commerce n\'est pas visible par les citoyens.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Color(0xFF6C757D), height: 1.4),
                  ),
                  const SizedBox(height: 24),
                  // Toggle stylé
                  GestureDetector(
                    onTap: _isLoading ? null : () => setState(() => _estPublie = !_estPublie),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      decoration: BoxDecoration(
                        color: _estPublie ? Colors.green[50] : Colors.grey[100],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _estPublie ? Colors.green[300]! : Colors.grey[300]!,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _estPublie ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                            color: _estPublie ? Colors.green[700] : Colors.grey[400],
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _estPublie ? 'Publié' : 'Brouillon',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: _estPublie ? Colors.green[700] : Colors.grey[600],
                                  ),
                                ),
                                Text(
                                  _estPublie ? 'Visible dans l\'annuaire' : 'Non visible',
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: _estPublie,
                            onChanged: _isLoading ? null : (v) => setState(() => _estPublie = v),
                            activeColor: const Color(0xFF8CD82C),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.info_outline, size: 14, color: Colors.grey),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Les commerces publiés apparaissent sur la carte et dans la liste des citoyens.',
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ),
                    ],
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: _isLoading
                    ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(color: Color(0xFF1E1E1E), strokeWidth: 2))
                    : const Text('Enregistrer', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
