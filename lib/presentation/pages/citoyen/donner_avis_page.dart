// lib/presentation/pages/citoyen/donner_avis_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/avis_provider.dart';
import '../../../core/theme/app_theme.dart';

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
  void dispose() { _commentaireCtrl.dispose(); super.dispose(); }

  Future<void> _soumettre() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(avisProvider.notifier).soumettre(
      commerceId: widget.commerceId,
      commentaire: _commentaireCtrl.text.trim(),
    );
    if (!mounted) return;
    final state = ref.read(avisProvider);
    if (state.succes) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Avis publié ! Note IA : ${state.dernierAvis?.noteIa ?? '?'}/5 ⭐'),
        backgroundColor: AppTheme.primaryContainer,
      ));
      context.pop();
    } else if (state.erreur != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(state.erreur!), backgroundColor: AppTheme.error));
    }
  }

  @override
  Widget build(BuildContext context) {
    final avisState = ref.watch(avisProvider);
    return Scaffold(
      backgroundColor: AppTheme.neutralSand,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceContainerLow,
        elevation: 0,
        foregroundColor: AppTheme.onSurface,
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded, color: AppTheme.primary), onPressed: () => context.pop()),
        title: const Text('Donner un avis', style: TextStyle(fontFamily: 'Hanken Grotesk', fontWeight: FontWeight.w700, color: AppTheme.primary)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header illustré
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.outlineVariant.withValues(alpha: 0.3)),
                  boxShadow: [BoxShadow(color: AppTheme.primary.withValues(alpha: 0.04), blurRadius: 12)],
                ),
                child: Column(children: [
                  Container(
                    width: 64, height: 64,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryContainer.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.rate_review_rounded, size: 32, color: AppTheme.primaryContainer),
                  ),
                  const SizedBox(height: 12),
                  const Text('Votre avis compte !', style: TextStyle(fontFamily: 'Hanken Grotesk', fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.onSurface)),
                  const SizedBox(height: 6),
                  const Text('Partagez votre expérience pour aider la communauté.', textAlign: TextAlign.center, style: TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 14, height: 1.4)),
                ]),
              ),
              const SizedBox(height: 20),

              // Commentaire
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.outlineVariant.withValues(alpha: 0.3)),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Votre commentaire', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: AppTheme.onSurface)),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _commentaireCtrl,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'Décrivez votre expérience avec cet artisan...',
                      fillColor: AppTheme.surfaceContainerLow,
                      filled: true,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                    validator: (v) => v!.trim().isEmpty ? 'Veuillez saisir un commentaire' : null,
                  ),
                ]),
              ),
              const SizedBox(height: 16),

              // Info IA
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.terracottaClay.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppTheme.terracottaClay.withValues(alpha: 0.25)),
                ),
                child: Row(children: [
                  const Icon(Icons.auto_awesome_rounded, color: AppTheme.terracottaClay, size: 20),
                  const SizedBox(width: 10),
                  Expanded(child: Text(
                    "Notre IA analysera automatiquement votre commentaire pour générer une note.",
                    style: TextStyle(fontSize: 13, color: AppTheme.terracottaClay.withValues(alpha: 0.9), height: 1.4),
                  )),
                ]),
              ),
              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity, height: 56,
                child: ElevatedButton(
                  onPressed: avisState.isLoading ? null : _soumettre,
                  style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                  child: avisState.isLoading
                      ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(color: AppTheme.onPrimary, strokeWidth: 2))
                      : const Text('Publier mon avis', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
