// lib/presentation/pages/auth/login_page.dart
// Page de connexion et d'inscription avec design sombre minimaliste
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/auth_provider.dart';
import '../../../core/utils/validators.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/design_system.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage>
    with SingleTickerProviderStateMixin {
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
    final s = ref.read(authProvider);
    if (s.erreur == null && s.user != null) {
      context.go(s.user!.onboardingFait
          ? (s.user!.estArtisan ? '/artisan/dashboard' : '/citoyen')
          : '/onboarding');
    }
  }

  Future<void> _sInscrire() async {
    if (!_registerFormKey.currentState!.validate()) return;
    await ref.read(authProvider.notifier).register(
      email: _registerEmailCtrl.text.trim(),
      password: _registerPasswordCtrl.text,
    );
    if (!mounted) return;
    final s = ref.read(authProvider);
    if (s.erreur == null && s.user != null) {
      context.go(s.user!.onboardingFait
          ? (s.user!.estArtisan ? '/artisan/dashboard' : '/citoyen')
          : '/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    return Scaffold(
      backgroundColor: AppTheme.fondPrincipal,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              // Logo + titre
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppTheme.accentSecondaire,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.handyman_rounded,
                      color: AppTheme.accentPrimaire,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Artisan BF',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textePrimaire,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Text(
                'Bienvenue',
                style: GoogleFonts.inter(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textePrimaire,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Connectez-vous pour accéder à votre espace.',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppTheme.texteSecondaire,
                ),
              ),
              const SizedBox(height: 28),

              // Card avec tabs
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.surfaceCard,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.bordureSubtile),
                ),
                child: Column(
                  children: [
                    // TabBar
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: Container(
                        height: 46,
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceCardHover,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TabBar(
                          controller: _tabController,
                          indicator: BoxDecoration(
                            color: AppTheme.accentSecondaire,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          labelColor: AppTheme.accentPrimaire,
                          unselectedLabelColor: AppTheme.texteSecondaire,
                          labelStyle: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                          tabs: const [
                            Tab(text: 'Connexion'),
                            Tab(text: 'Inscription'),
                          ],
                        ),
                      ),
                    ),
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
            AppInput(
              label: 'Email',
              hint: 'votre@email.com',
              icon: Icons.email_outlined,
              controller: _loginEmailCtrl,
              validator: Validators.email,
            ),
            const SizedBox(height: 14),
            AppInput(
              label: 'Mot de passe',
              hint: '••••••••',
              icon: Icons.lock_outline_rounded,
              controller: _loginPasswordCtrl,
              isPassword: true,
              obscureText: !_loginMdpVisible,
              onToggleVisibility: () =>
                  setState(() => _loginMdpVisible = !_loginMdpVisible),
              validator: Validators.password,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => context.push('/reset-password'),
                child: Text(
                  'Mot de passe oublié ?',
                  style: GoogleFonts.inter(
                    color: AppTheme.texteSecondaire,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            if (authState.erreur != null)
              ErrorBanner(message: authState.erreur!),
            const SizedBox(height: 8),
            PrimaryButton(
              label: 'Se connecter',
              isLoading: authState.isLoading,
              onPressed: _seConnecter,
              icon: Icons.login_rounded,
            ),
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
            AppInput(
              label: 'Nom complet',
              hint: 'Amadou Ouédraogo',
              icon: Icons.person_outline_rounded,
              controller: _registerNomCtrl,
              validator: Validators.nom,
            ),
            const SizedBox(height: 12),
            AppInput(
              label: 'Email',
              hint: 'votre@email.com',
              icon: Icons.email_outlined,
              controller: _registerEmailCtrl,
              validator: Validators.email,
            ),
            const SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Téléphone',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.texteSecondaire,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 14),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceCard,
                        border: Border.all(color: AppTheme.bordureSubtile),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        '+226',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textePrimaire,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _registerTelCtrl,
                        keyboardType: TextInputType.phone,
                        validator: Validators.telephone,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppTheme.textePrimaire,
                        ),
                        decoration: InputDecoration(
                          hintText: '00 00 00 00',
                          filled: true,
                          fillColor: AppTheme.surfaceCard,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide:
                                const BorderSide(color: AppTheme.bordureSubtile),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide:
                                const BorderSide(color: AppTheme.bordureSubtile),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            AppInput(
              label: 'Mot de passe',
              hint: '••••••••',
              icon: Icons.lock_outline_rounded,
              controller: _registerPasswordCtrl,
              isPassword: true,
              obscureText: !_registerMdpVisible,
              onToggleVisibility: () =>
                  setState(() => _registerMdpVisible = !_registerMdpVisible),
              validator: Validators.password,
            ),
            const SizedBox(height: 12),
            AppInput(
              label: 'Confirmer',
              hint: '••••••••',
              icon: Icons.lock_outline_rounded,
              controller: _registerConfirmCtrl,
              isPassword: true,
              obscureText: !_registerMdpVisible,
              validator: (v) =>
                  v == _registerPasswordCtrl.text ? null : 'Les mots de passe ne correspondent pas',
            ),
            if (authState.erreur != null)
              ErrorBanner(message: authState.erreur!),
            const SizedBox(height: 16),
            PrimaryButton(
              label: 'Créer mon compte',
              isLoading: authState.isLoading,
              onPressed: _sInscrire,
              icon: Icons.person_add_rounded,
            ),
          ],
        ),
      ),
    );
  }
}