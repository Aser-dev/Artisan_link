// lib/presentation/pages/auth/login_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../../core/utils/validators.dart';
import '../../../core/theme/app_theme.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _loginFormKey = GlobalKey<FormState>();
  final _loginEmailCtrl = TextEditingController();
  final _loginPasswordCtrl = TextEditingController();
  bool _loginMdpVisible = false;

  final _registerFormKey = GlobalKey<FormState>();
  final _registerNomCtrl = TextEditingController();
  final _registerEmailCtrl = TextEditingController();
  final _registerTelCtrl = TextEditingController();
  final _registerPasswordCtrl = TextEditingController();
  final _registerConfirmCtrl = TextEditingController();
  bool _registerMdpVisible = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _loginEmailCtrl.dispose(); _loginPasswordCtrl.dispose();
    _registerNomCtrl.dispose(); _registerEmailCtrl.dispose();
    _registerTelCtrl.dispose(); _registerPasswordCtrl.dispose();
    _registerConfirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _seConnecter() async {
    if (!_loginFormKey.currentState!.validate()) return;
    await ref.read(authProvider.notifier).login(email: _loginEmailCtrl.text.trim(), password: _loginPasswordCtrl.text);
    if (!mounted) return;
    final s = ref.read(authProvider);
    if (s.erreur == null && s.user != null) {
      context.go(s.user!.onboardingFait ? (s.user!.estArtisan ? '/artisan/dashboard' : '/citoyen') : '/onboarding');
    }
  }

  Future<void> _sInscrire() async {
    if (!_registerFormKey.currentState!.validate()) return;
    await ref.read(authProvider.notifier).register(
      nom: _registerNomCtrl.text.trim(), email: _registerEmailCtrl.text.trim(),
      telephone: _registerTelCtrl.text.trim(), password: _registerPasswordCtrl.text,
    );
    if (!mounted) return;
    final s = ref.read(authProvider);
    if (s.erreur == null && s.emailConfirmationSent) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Un lien de confirmation a été envoyé à ${_registerEmailCtrl.text.trim()}'),
          backgroundColor: AppTheme.primary,
          duration: const Duration(seconds: 5),
        ),
      );
      _tabController.animateTo(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    return Scaffold(
      backgroundColor: AppTheme.neutralSand,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              // Logo + titre
              Row(children: [
                Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(color: AppTheme.primaryContainer, borderRadius: BorderRadius.circular(14)),
                  child: const Icon(Icons.handyman_rounded, color: AppTheme.onPrimaryContainer, size: 26),
                ),
                const SizedBox(width: 12),
                const Text('Artisan Core', style: TextStyle(fontFamily: 'Hanken Grotesk', fontSize: 20, fontWeight: FontWeight.w700, color: AppTheme.primary)),
              ]),
              const SizedBox(height: 32),
              const Text('Bienvenue', style: TextStyle(fontFamily: 'Hanken Grotesk', fontSize: 28, fontWeight: FontWeight.w700, color: AppTheme.onSurface)),
              const SizedBox(height: 4),
              const Text('Connectez-vous pour accéder à votre espace.', style: TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 14)),
              const SizedBox(height: 28),

              // Card principale
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.outlineVariant.withOpacity(0.3)),
                  boxShadow: [BoxShadow(color: AppTheme.primary.withOpacity(0.05), blurRadius: 16)],
                ),
                child: Column(
                  children: [
                    // TabBar
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: Container(
                        height: 46,
                        decoration: BoxDecoration(color: AppTheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(10)),
                        child: TabBar(
                          controller: _tabController,
                          indicator: BoxDecoration(color: AppTheme.surfaceContainerLowest, borderRadius: BorderRadius.circular(8),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 4)]),
                          labelColor: AppTheme.onSurface,
                          unselectedLabelColor: AppTheme.onSurfaceVariant,
                          labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                          tabs: const [Tab(text: 'Connexion'), Tab(text: 'Inscription')],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 400,
                      child: TabBarView(
                        controller: _tabController,
                        children: [_buildLoginForm(authState), _buildRegisterForm(authState)],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm(AuthState authState) {
    return Form(
      key: _loginFormKey,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 4),
            _field(label: 'Email', hint: 'votre@email.com', icon: Icons.email_outlined, ctrl: _loginEmailCtrl, validator: Validators.email),
            const SizedBox(height: 14),
            _field(label: 'Mot de passe', hint: '••••••••', icon: Icons.lock_outline_rounded, ctrl: _loginPasswordCtrl,
              isPassword: true, mdpVisible: _loginMdpVisible,
              onToggle: () => setState(() => _loginMdpVisible = !_loginMdpVisible), validator: Validators.password),
            Align(alignment: Alignment.centerRight,
              child: TextButton(onPressed: () => context.push('/reset-password'),
                child: const Text('Mot de passe oublié ?', style: TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 13)))),
            if (authState.erreur != null) _erreur(authState.erreur!),
            const SizedBox(height: 8),
            SizedBox(width: double.infinity, height: 52,
              child: ElevatedButton(
                onPressed: authState.isLoading ? null : _seConnecter,
                child: authState.isLoading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: AppTheme.onPrimary, strokeWidth: 2))
                    : const Text('Se connecter', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
              )),
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterForm(AuthState authState) {
    return Form(
      key: _registerFormKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _field(label: 'Nom complet', hint: 'Amadou Ouédraogo', icon: Icons.person_outline_rounded, ctrl: _registerNomCtrl, validator: Validators.nom),
            const SizedBox(height: 12),
            _field(label: 'Email', hint: 'votre@email.com', icon: Icons.email_outlined, ctrl: _registerEmailCtrl, validator: Validators.email),
            const SizedBox(height: 12),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Téléphone', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              const SizedBox(height: 8),
              Row(children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  decoration: BoxDecoration(border: Border.all(color: AppTheme.outline), borderRadius: BorderRadius.circular(8)),
                  child: const Text('+226', style: TextStyle(fontWeight: FontWeight.w600)),
                ),
                const SizedBox(width: 8),
                Expanded(child: TextFormField(controller: _registerTelCtrl, keyboardType: TextInputType.phone, validator: Validators.telephone,
                  decoration: const InputDecoration(hintText: '00 00 00 00'))),
              ]),
            ]),
            const SizedBox(height: 12),
            _field(label: 'Mot de passe', hint: '••••••••', icon: Icons.lock_outline_rounded, ctrl: _registerPasswordCtrl,
              isPassword: true, mdpVisible: _registerMdpVisible,
              onToggle: () => setState(() => _registerMdpVisible = !_registerMdpVisible), validator: Validators.password),
            const SizedBox(height: 12),
            _field(label: 'Confirmer', hint: '••••••••', icon: Icons.lock_outline_rounded, ctrl: _registerConfirmCtrl,
              isPassword: true, mdpVisible: _registerMdpVisible,
              validator: (v) => v == _registerPasswordCtrl.text ? null : 'Les mots de passe ne correspondent pas'),
            if (authState.erreur != null) _erreur(authState.erreur!),
            const SizedBox(height: 16),
            SizedBox(width: double.infinity, height: 52,
              child: ElevatedButton(
                onPressed: authState.isLoading ? null : _sInscrire,
                child: authState.isLoading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: AppTheme.onPrimary, strokeWidth: 2))
                    : const Text('Créer mon compte', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
              )),
          ],
        ),
      ),
    );
  }

  Widget _field({required String label, required String hint, required IconData icon, required TextEditingController ctrl,
    bool isPassword = false, bool mdpVisible = false, VoidCallback? onToggle, String? Function(String?)? validator}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppTheme.onSurface)),
      const SizedBox(height: 6),
      TextFormField(
        controller: ctrl, obscureText: isPassword && !mdpVisible, validator: validator,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: AppTheme.onSurfaceVariant, size: 20),
          suffixIcon: isPassword ? IconButton(icon: Icon(mdpVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: AppTheme.onSurfaceVariant, size: 20), onPressed: onToggle) : null,
        ),
      ),
    ]);
  }

  Widget _erreur(String msg) => Container(
    margin: const EdgeInsets.only(top: 10),
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(color: AppTheme.errorContainer, borderRadius: BorderRadius.circular(8)),
    child: Row(children: [
      const Icon(Icons.error_outline_rounded, color: AppTheme.error, size: 16),
      const SizedBox(width: 8),
      Expanded(child: Text(msg, style: const TextStyle(color: AppTheme.error, fontSize: 12))),
    ]),
  );
}
