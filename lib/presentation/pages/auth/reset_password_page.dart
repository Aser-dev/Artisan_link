// lib/presentation/pages/auth/reset_password_page.dart
// Demande de réinitialisation de mot de passe par email
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/auth_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/validators.dart';

class ResetPasswordPage extends ConsumerStatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  ConsumerState<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends ConsumerState<ResetPasswordPage> {
  final _emailCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _envoye = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _envoyer() async {
    if (!_formKey.currentState!.validate()) return;
    final succes = await ref.read(authProvider.notifier).resetPassword(
          email: _emailCtrl.text.trim(),
        );
    if (succes && mounted) setState(() => _envoye = true);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppTheme.fondPrincipal,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 40),
                // Logo
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppTheme.accentSecondaire,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.handyman_rounded,
                      size: 36, color: AppTheme.accentPrimaire),
                ),
                const SizedBox(height: 16),
                Text('Artisan BF',
                    style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textePrimaire)),
                const SizedBox(height: 40),

                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _envoye ? _buildSucces() : _buildForm(authState),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSucces() {
    return Container(
      key: const ValueKey('succes'),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.bordureSubtile),
      ),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppTheme.accentSecondaire.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.mark_email_read_outlined,
                size: 38, color: AppTheme.accentPrimaire),
          ),
          const SizedBox(height: 20),
          Text('Email envoyé !',
              style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textePrimaire)),
          const SizedBox(height: 10),
          Text(
            'Un lien de réinitialisation a été envoyé à\n${_emailCtrl.text}',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
                color: AppTheme.texteSecondaire, height: 1.5),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: () => context.go('/login'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentPrimaire,
                  foregroundColor: const Color(0xFF0F0F0F),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14))),
              child: const Text('Retour à la connexion',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(AuthState authState) {
    return Container(
      key: const ValueKey('form'),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.bordureSubtile),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Mot de passe oublié ?',
                style: GoogleFonts.inter(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textePrimaire)),
            const SizedBox(height: 8),
            Text(
              'Entrez votre email pour recevoir un lien de réinitialisation.',
              style: GoogleFonts.inter(
                  color: AppTheme.texteSecondaire,
                  fontSize: 14,
                  height: 1.4),
            ),
            const SizedBox(height: 24),
            Text('Email',
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.texteSecondaire)),
            const SizedBox(height: 8),
            TextFormField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              style: GoogleFonts.inter(color: AppTheme.textePrimaire),
              decoration: InputDecoration(
                hintText: 'votre@email.com',
                prefixIcon:
                    const Icon(Icons.email_outlined, color: AppTheme.texteSecondaire),
                filled: true,
                fillColor: AppTheme.surfaceCardHover,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
              validator: Validators.email,
            ),
            if (authState.erreur != null) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.erreur.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline,
                        color: AppTheme.erreur, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                        child: Text(authState.erreur!,
                            style: GoogleFonts.inter(
                                color: AppTheme.erreur, fontSize: 12))),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: authState.isLoading ? null : _envoyer,
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentPrimaire,
                    foregroundColor: const Color(0xFF0F0F0F),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14))),
                child: authState.isLoading
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                            color: Color(0xFF0F0F0F), strokeWidth: 2))
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Envoyer le lien',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward_rounded, size: 18),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: TextButton.icon(
                onPressed: () => context.go('/login'),
                icon: const Icon(Icons.arrow_back_rounded,
                    size: 16, color: AppTheme.texteSecondaire),
                label: Text('Retour à la connexion',
                    style: GoogleFonts.inter(color: AppTheme.texteSecondaire)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}