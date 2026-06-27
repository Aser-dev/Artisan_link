// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialiser Supabase (remplacer par vos vraies clés)
  await Supabase.initialize(
    url: 'https://votre-projet.supabase.co',
    anonKey: 'votre-clé-anon',
  );

  runApp(const ProviderScope(child: ArtisanBfApp()));
}

class ArtisanBfApp extends StatelessWidget {
  const ArtisanBfApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'ArtisanBF',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      routerConfig: appRouter,
    );
  }
}
