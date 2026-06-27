// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';
import 'presentation/providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://skebhzipxbzstmzqchhd.supabase.co',
    publishableKey: 'sb_publishable_C7sIHh2OpoW-WNkQiytPRw_YM5ojUQw',
  );
  runApp(const ProviderScope(child: ArtisanBfApp()));
}

class ArtisanBfApp extends ConsumerStatefulWidget {
  const ArtisanBfApp({super.key});

  @override
  ConsumerState<ArtisanBfApp> createState() => _ArtisanBfAppState();
}

class _ArtisanBfAppState extends ConsumerState<ArtisanBfApp> {
  @override
  void initState() {
    super.initState();
    ref.read(authProvider.notifier).setPasswordRecoveryCallback(() {
      appRouter.go('/new-password');
    });
  }

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
