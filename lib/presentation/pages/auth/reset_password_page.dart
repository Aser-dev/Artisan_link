import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart';

class ResetPasswordPage extends ConsumerStatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  ConsumerState<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends ConsumerState<ResetPasswordPage> {
  final _emailController = TextEditingController();
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleReset() async {
    if (_emailController.text.trim().isEmpty) return;

    ref.read(authNotifierProvider.notifier).clearError();
    await ref
        .read(authNotifierProvider.notifier)
        .resetPassword(_emailController.text.trim());

    if (mounted && ref.read(authNotifierProvider).error == null) {
      setState(() => _emailSent = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              // Logo Icône Vert
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppTheme.primaryGreen,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(
                  Icons.brush,
                  size: 40,
                  color: AppTheme.darkText,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'FasoArtisan',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkGreen,
                ),
              ),
              const Spacer(flex: 1),

              // Boîte blanche du formulaire
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppTheme.borderColor),
                ),
                child: _emailSent
                    ? _buildSuccessContent()
                    : _buildFormContent(authState),
              ),
              const Spacer(flex: 3),

              // Footer
              const Text(
                '©️ 2024 FasoArtisan. Tous droits réservés.',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormContent(AuthUiState authState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mot de passe oublié ?',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppTheme.darkText,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Entrez votre email pour recevoir un lien de réinitialisation.',
          style: TextStyle(color: AppTheme.greyText, fontSize: 14),
        ),
        const SizedBox(height: 24),
        const Text(
          'Email',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppTheme.darkText,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _emailController,
          decoration: const InputDecoration(
            hintText: 'votre@email.com',
            prefixIcon: Icon(Icons.email_outlined, color: Colors.grey),
          ),
        ),
        const SizedBox(height: 8),

        // Erreur
        if (authState.error != null) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    authState.error!,
                    style: const TextStyle(color: Colors.red, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],

        const SizedBox(height: 16),

        // Bouton Envoyer
        SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: authState.isLoading ? null : _handleReset,
            child: authState.isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppTheme.darkText,
                    ),
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Envoyer le lien ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Icon(Icons.arrow_forward, size: 18),
                    ],
                  ),
          ),
        ),
        const SizedBox(height: 24),

        // Retour
        Center(
          child: TextButton.icon(
            onPressed: () => context.pop(),
            icon: const Icon(
              Icons.arrow_back,
              size: 16,
              color: Color(0xFF495057),
            ),
            label: const Text(
              'Retour à la connexion',
              style: TextStyle(
                color: Color(0xFF495057),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessContent() {
    return Column(
      children: [
        const Icon(Icons.check_circle_outline, size: 64, color: Colors.green),
        const SizedBox(height: 16),
        const Text(
          'Email envoyé !',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Si un compte existe avec cet email,\nvous recevrez un lien de réinitialisation.',
          style: TextStyle(color: AppTheme.greyText, fontSize: 14),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: () => context.pop(),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Retour à la connexion ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Icon(Icons.arrow_forward, size: 18),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
