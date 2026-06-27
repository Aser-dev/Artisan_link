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
    await ref.read(avisProvider.notifier).soumettre(
      commerceId: widget.commerceId,
      commentaire: _commentaireCtrl.text.trim(),
    );
    if (!mounted) return;
    final state = ref.read(avisProvider);
    if (state.succes) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Avis publié ! Note IA : ${state.dernierAvis?.noteIa ?? '?'} ⭐'),
          backgroundColor: Colors.green[700],
        ),
      );
      context.pop();
    } else if (state.erreur != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ ${state.erreur}'), backgroundColor: Colors.red[700]),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final avisState = ref.watch(avisProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Donner un avis', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: const Color(0xFF1E1E1E),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Illustration header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE9ECEF)),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.rate_review_rounded, size: 32, color: Color(0xFF2E4A0B)),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Votre avis compte !',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E1E)),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Partagez votre expérience pour aider la communauté.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF6C757D), fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Champ commentaire
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
                    const Text('Votre commentaire', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _commentaireCtrl,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'Décrivez votre expérience avec cet artisan...',
                        fillColor: const Color(0xFFF8F9FA),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        filled: true,
                      ),
                      validator: (v) => v!.trim().isEmpty ? 'Veuillez saisir un commentaire' : null,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Info IA
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.amber[50],
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.amber[200]!),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.auto_awesome_rounded, color: Colors.amber, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Notre IA analysera automatiquement votre commentaire pour générer une note.",
                        style: TextStyle(fontSize: 13, color: Colors.amber[900]),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: avisState.isLoading ? null : _soumettre,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: avisState.isLoading
                      ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(color: Color(0xFF1E1E1E), strokeWidth: 2))
                      : const Text('Publier mon avis', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
