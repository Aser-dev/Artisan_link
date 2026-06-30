// lib/presentation/pages/preview/preview_menu_page.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../splash/splash_page.dart';
import '../auth/login_page.dart';
import '../auth/register_page.dart';
import '../auth/reset_password_page.dart';
import '../auth/reset_password_confirm_page.dart';
import '../onboarding/onboarding_page.dart';
import '../citoyen/accueil_citoyen_page.dart';
import '../citoyen/carte_page.dart';
import '../citoyen/detail_commerce_page.dart';
import '../citoyen/donner_avis_page.dart';
import '../citoyen/liste_recherche_page.dart';
import '../artisan/dashboard_artisan_page.dart';
import '../artisan/creer_commerce_page.dart';
import '../artisan/editer_commerce_page.dart';
import '../artisan/gerer_publication_page.dart';

class PreviewMenuPage extends StatelessWidget {
  const PreviewMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🧭 ArtisanBF - Preview'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle('🏁 Écrans de démarrage'),
          _buildMenuItem(context, 'Splash Page', const SplashPage()),
          _buildMenuItem(context, 'Login', const LoginPage()),
          _buildMenuItem(context, 'Register', const RegisterPage()),
          _buildMenuItem(context, 'Reset Password', const ResetPasswordPage()),
          _buildMenuItem(context, 'Confirm Reset', const ResetPasswordConfirmPage()),
          _buildMenuItem(
            context,
            'Onboarding (choix rôle)',
            const OnboardingPage(),
          ),

          const Divider(height: 32),
          _buildSectionTitle('👤 Branche Citoyen'),
          _buildMenuItem(
            context,
            'Accueil Citoyen (Carte/Liste)',
            const AccueilCitoyenPage(),
          ),
          _buildMenuItem(context, 'Carte OpenStreetMap', const CartePage()),
          _buildMenuItem(
            context,
            'Détail Commerce',
            const DetailCommercePage(commerceId: 'preview'),
          ),

          _buildMenuItem(
            context,
            'Donner un Avis',
            const DonnerAvisPage(commerceId: 'preview'),
          ),

          const Divider(height: 32),
          _buildSectionTitle('🔧 Branche Artisan'),
          _buildMenuItem(
            context,
            'Dashboard Artisan',
            const DashboardArtisanPage(),
          ),
          _buildMenuItem(
            context,
            'Créer un Commerce',
            const CreerCommercePage(),
          ),
          _buildMenuItem(context, 'Editer Commerce', const EditerCommercePage(commerceId: 'preview')),
          _buildMenuItem(context, 'Gérer Publication', const GererPublicationPage(commerceId: 'preview', estPublieActuel: true)),
          _buildMenuItem(context, 'Recherche Commerce', const ListeRecherchePage()),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, Widget page) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            context.push('/preview/${page.runtimeType}');
          },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
