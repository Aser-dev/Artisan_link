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
    _loginEmailCtrl.dispose();
    _loginPasswordCtrl.dispose();
    _registerNomCtrl.dispose();
    _registerEmailCtrl.dispose();
    _registerTelCtrl.dispose();
    _registerPasswordCtrl.dispose();
    _registerConfirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _seConnecter() async {
    if (!_loginFormKey.currentState!.validate()) return;
    await ref.read(authProvider.notifier).login(
      email: _loginEmailCtrl.text.trim(),
      password: _loginPasswordCtrl.text,
    );
    if (!mounted) return;
    final state = ref.read(authProvider);
    if (state.erreur == null && state.user != null) {
      context.go(state.user!.onboardingFait
          ? (state.user!.estArtisan ? '/artisan/dashboard' : '/citoyen')
          : '/onboarding');
    }
  }

  Future<void> _sInscrire() async {
    if (!_registerFormKey.currentState!.validate()) return;
    await ref.read(authProvider.notifier).register(
      nom: _registerNomCtrl.text.trim(),
      email: _registerEmailCtrl.text.trim(),
      telephone: _registerTelCtrl.text.trim(),
      password: _registerPasswordCtrl.text,
    );
    if (!mounted) return;
    final state = ref.read(authProvider);
    if (state.erreur == null && state.user != null) {
      context.go('/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('ArtisanBF',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryDark)),
                  IconButton(
                    icon: const Icon(Icons.help_outline, color: Colors.grey),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 40),
              const Text.rich(
                TextSpan(
                  text: 'Propulsez votre\n',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppTheme.textDark, height: 1.2),
                  children: [TextSpan(text: 'artisanat.', style: TextStyle(color: AppTheme.primaryDark))],
                ),
              ),
              const SizedBox(height: 8),
              const Text('Connectez-vous pour accéder à votre espace.',
                  style: TextStyle(color: Colors.grey, fontSize: 15)),
              const SizedBox(height: 32),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppTheme.borderLight),
                ),
                child: Column(
                  children: [
                    Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppTheme.inputBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        indicator: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2)),
                          ],
                        ),
                        labelColor: AppTheme.textDark,
                        unselectedLabelColor: Colors.grey,
                        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                        tabs: const [Tab(text: 'Connexion'), Tab(text: 'Inscription')],
                      ),
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      height: 420,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildLoginForm(authState),
                          _buildRegisterForm(authState),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm(AuthState authState) {
    return Form(
      key: _loginFormKey,
      child: Column(
        children: [
          const SizedBox(height: 20),
          _buildInput(
            label: 'Email',
            hint: 'votre@email.com',
            icon: Icons.mail_outline,
            controller: _loginEmailCtrl,
            validator: Validators.email,
          ),
          const SizedBox(height: 16),
          _buildInput(
            label: 'Mot de passe',
            hint: '••••••••',
            icon: Icons.lock_outline,
            controller: _loginPasswordCtrl,
            isPassword: true,
            mdpVisible: _loginMdpVisible,
            onToggleMdp: () => setState(() => _loginMdpVisible = !_loginMdpVisible),
            validator: Validators.password,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => context.push('/reset-password'),
              child: const Text('Mot de passe oublié ?', style: TextStyle(color: Color(0xFF495057))),
            ),
          ),
          if (authState.erreur != null) _buildErreur(authState.erreur!),
          const SizedBox(height: 8),
          _buildBoutonPrincipal(
            label: 'Accéder à l\'espace',
            isLoading: authState.isLoading,
            onPressed: _seConnecter,
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterForm(AuthState authState) {
    return Form(
      key: _registerFormKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildInput(
              label: 'Nom complet',
              hint: 'Amadou Ouédraogo',
              icon: Icons.person_outline,
              controller: _registerNomCtrl,
              validator: Validators.nom,
            ),
            const SizedBox(height: 12),
            _buildInput(
              label: 'Email',
              hint: 'votre@email.com',
              icon: Icons.mail_outline,
              controller: _registerEmailCtrl,
              validator: Validators.email,
            ),
            const SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Téléphone', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                      decoration: BoxDecoration(
                        color: AppTheme.inputBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text('🇧🇫 +226', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _registerTelCtrl,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(hintText: '00 00 00 00', prefixIcon: Icon(Icons.phone_outlined)),
                        validator: Validators.telephone,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInput(
              label: 'Mot de passe',
              hint: '••••••••',
              icon: Icons.lock_outline,
              controller: _registerPasswordCtrl,
              isPassword: true,
              mdpVisible: _registerMdpVisible,
              onToggleMdp: () => setState(() => _registerMdpVisible = !_registerMdpVisible),
              validator: Validators.password,
            ),
            const SizedBox(height: 12),
            _buildInput(
              label: 'Confirmer',
              hint: '••••••••',
              icon: Icons.lock_outline,
              controller: _registerConfirmCtrl,
              isPassword: true,
              mdpVisible: _registerMdpVisible,
              validator: (v) => v == _registerPasswordCtrl.text ? null : 'Les mots de passe ne correspondent pas',
            ),
            if (authState.erreur != null) _buildErreur(authState.erreur!),
            const SizedBox(height: 16),
            _buildBoutonPrincipal(
              label: 'Créer mon compte',
              isLoading: authState.isLoading,
              onPressed: _sInscrire,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    bool isPassword = false,
    bool mdpVisible = false,
    VoidCallback? onToggleMdp,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPassword && !mdpVisible,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: Colors.grey),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(mdpVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: Colors.grey),
                    onPressed: onToggleMdp,
                  )
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildErreur(String message) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.red[50], borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 16),
          const SizedBox(width: 8),
          Expanded(child: Text(message, style: const TextStyle(color: Colors.red, fontSize: 12))),
        ],
      ),
    );
  }

  Widget _buildBoutonPrincipal({
    required String label,
    required bool isLoading,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(color: Color(0xFF1E1E1E), strokeWidth: 2))
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward, size: 18),
                ],
              ),
      ),
    );
  }
}