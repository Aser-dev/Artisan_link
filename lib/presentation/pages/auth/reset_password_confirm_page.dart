// lib/presentation/pages/auth/reset_password_confirm_page.dart
// Définition du nouveau mot de passe après réinitialisation
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../widgets/design_system.dart';
import '../../../core/theme/app_theme.dart';

class ResetPasswordConfirmPage extends ConsumerStatefulWidget {
  const ResetPasswordConfirmPage({super.key});

  @override
  ConsumerState<ResetPasswordConfirmPage> createState() =>
      _ResetPasswordConfirmPageState();
}

class _ResetPasswordConfirmPageState
    extends ConsumerState<ResetPasswordConfirmPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _isLoading = false;
  bool _mdpVisible = false;
  String? _erreur;

  @override
  void dispose() {
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _enregistrer() async {
    if (!_formKey.currentState!.validate()) return;
    HapticFeedback.lightImpact();
    setState(() {
      _isLoading = true;
      _erreur = null;
    });
    try {
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(password: _passwordCtrl.text),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Mot de passe mis à jour !'),
          backgroundColor: AppTheme.accentSecondaire,
        ),
      );
      context.go('/login');
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _erreur = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.fondPrincipal,
      appBar: AppBar(
        backgroundColor: AppTheme.fondPrincipal,
        elevation: 0,
        foregroundColor: AppTheme.textePrimaire,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
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
                    Text(
                      'Nouveau mot de passe',
                      style: GoogleFonts.inter(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textePrimaire,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Choisissez un nouveau mot de passe sécurisé.',
                      style: GoogleFonts.inter(
                        color: AppTheme.texteSecondaire,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),
                    AppInput(
                      label: 'Nouveau mot de passe',
                      hint: 'Minimum 6 caractères',
                      icon: Icons.lock_outline_rounded,
                      controller: _passwordCtrl,
                      isPassword: true,
                      obscureText: !_mdpVisible,
                      onToggleVisibility: () =>
                          setState(() => _mdpVisible = !_mdpVisible),
                      validator: (v) =>
                          (v == null || v.length < 6) ? 'Minimum 6 caractères' : null,
                    ),
                    const SizedBox(height: 14),
                    AppInput(
                      label: 'Confirmer le mot de passe',
                      hint: 'Retapez votre mot de passe',
                      icon: Icons.lock_outline_rounded,
                      controller: _confirmCtrl,
                      isPassword: true,
                      obscureText: !_mdpVisible,
                      onToggleVisibility: () =>
                          setState(() => _mdpVisible = !_mdpVisible),
                      validator: (v) =>
                          v != _passwordCtrl.text ? 'Les mots de passe ne correspondent pas' : null,
                    ),
                    if (_erreur != null) ...[
                      const SizedBox(height: 12),
                      ErrorBanner(message: _erreur!),
                    ],
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _enregistrer,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.accentPrimaire,
                          foregroundColor: const Color(0xFF0F0F0F),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2))
                            : const Text('Enregistrer',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}