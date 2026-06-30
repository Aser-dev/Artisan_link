// lib/presentation/pages/citoyen/donner_avis_page.dart
// Page de soumission d'avis avec analyse IA (Sentiment → note)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/avis_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/design_system.dart';

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
    HapticFeedback.lightImpact();
    await ref.read(avisProvider.notifier).soumettre(
          commerceId: widget.commerceId,
          commentaire: _commentaireCtrl.text.trim(),
        );
    if (!mounted) return;
    final state = ref.read(avisProvider);
    if (state.succes) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Avis publié ! Note IA : ${state.dernierAvis?.noteIa ?? '?'}/5 ⭐'),
          backgroundColor: AppTheme.accentSecondaire,
        ),
      );
      context.pop();
    } else if (state.erreur != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.erreur!),
          backgroundColor: AppTheme.erreur,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final avisState = ref.watch(avisProvider);
    return Scaffold(
      backgroundColor: AppTheme.fondPrincipal,
      appBar: AppBar(
        backgroundColor: AppTheme.fondPrincipal,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded,
              color: AppTheme.textePrimaire),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Donner un avis',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            color: AppTheme.textePrimaire,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceCard,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.bordureSubtile),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: AppTheme.accentSecondaire
                            .withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.rate_review_rounded,
                          size: 32, color: AppTheme.accentPrimaire),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Votre avis compte !',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textePrimaire,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Partagez votre expérience pour aider la communauté.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        color: AppTheme.texteSecondaire,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Commentaire
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceCard,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.bordureSubtile),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Votre commentaire',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: AppTheme.textePrimaire,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _commentaireCtrl,
                      maxLines: 5,
                      style: GoogleFonts.inter(
                          fontSize: 14, color: AppTheme.textePrimaire),
                      decoration: InputDecoration(
                        hintText:
                            'Décrivez votre expérience avec cet artisan...',
                        filled: true,
                        fillColor: AppTheme.surfaceCardHover,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (v) =>
                          v!.trim().isEmpty ? 'Veuillez saisir un commentaire' : null,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Info IA
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.accentSecondaire.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color:
                          AppTheme.accentSecondaire.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.auto_awesome_rounded,
                        color: AppTheme.accentPrimaire, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Notre IA analysera automatiquement votre commentaire pour générer une note.",
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppTheme.accentPrimaire,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              PrimaryButton(
                label: 'Publier mon avis',
                isLoading: avisState.isLoading,
                onPressed: _soumettre,
                icon: Icons.send_rounded,
              ),
            ],
          ),
        ),
      ),
    );
  }
}