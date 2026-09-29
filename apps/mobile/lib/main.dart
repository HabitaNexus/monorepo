import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitanexus_mobile/config/app_router.dart';
import 'package:habitanexus_mobile/config/demo_data.dart';
import 'package:habitanexus_mobile/core/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    // demoOverrides: repositorio local sin backend (temporal).
    ProviderScope(
      overrides: demoOverrides,
      child: const HabitaNexusApp(),
    ),
  );
}

class HabitaNexusApp extends ConsumerWidget {
  const HabitaNexusApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      routerConfig: router,
      title: 'HabitaNexus',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
    );
  }
}
