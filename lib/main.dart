// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://skebhzipxbzstmzqchhd.supabase.co',
    anonKey: 'sb_publishable_C7sIHh2OpoW-WNkQiytPRw_YM5ojUQw',
    authOptions: const FlutterAuthClientOptions(
      authFlowType: OAuthFlow.pkce,
    ),
  );
  runApp(const ProviderScope(child: ArtisanBfApp()));
}

class ArtisanBfApp extends StatelessWidget {
  const ArtisanBfApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Artisan Core',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      routerConfig: appRouter,
    );
  }
}
