import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/avis_provider.dart';

class DonnerAvisPage extends ConsumerStatefulWidget {
  final String commerceId;
  const DonnerAvisPage({super.key, required this.commerceId});

  @override
  ConsumerState<DonnerAvisPage> createState() => _DonnerAvisPageState();
}

class _DonnerAvisPageState extends ConsumerState<DonnerAvisPage> {
  final _commentaireCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _commentaireCtrl.dispose();
    super.dispose();
  }

  Future<void> _soumettre() async {
    if (!_formKey.currentState!.validate()) return;
    final commentaire = _commentaireCtrl.text.trim();

    await ref
        .read(avisProvider.notifier)
        .soumettre(commerceId: widget.commerceId, commentaire: commentaire);

    if (!mounted) return;

    final state = ref.read(avisProvider);
    if (state.succes) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '✅ Avis publié ! Note IA : ${state.dernierAvis?.noteIa ?? '?'} ⭐',
          ),
          backgroundColor: Colors.green,
        ),
      );
      context.pop();
    } else if (state.erreur != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('❌ ${state.erreur}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final avisState = ref.watch(avisProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Donner un avis'),
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        foregroundColor: const Color(0xFF1E1E1E),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text(
                'Partagez votre expérience avec cet artisan.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _commentaireCtrl,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Écrivez votre avis ici...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (v) =>
                    v!.trim().isEmpty ? 'Veuillez saisir un commentaire' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.amber),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "L'IA analysera automatiquement votre commentaire lors de la publication.",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: avisState.isLoading ? null : _soumettre,
                  child: avisState.isLoading
                      ? const CircularProgressIndicator(
                          color: Color(0xFF1E1E1E),
                          strokeWidth: 2,
                        )
                      : const Text(
                          'Publier mon avis',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
