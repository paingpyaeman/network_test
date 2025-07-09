import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/theme/theme_provider.dart';
import 'package:go_router/go_router.dart';

class AppScaffold extends ConsumerWidget {
  final Widget child;
  const AppScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riverpod App'),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => toggleTheme(ref),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Navigation Menu'),
            ),
            ListTile(
              title: const Text('Account Management'),
              onTap: () {
                Navigator.pop(context); // Close drawer
                context.go('/account');
              },
            ),
            ListTile(
              title: const Text('Pay Account'),
              onTap: () {
                Navigator.pop(context); // Close drawer
                context.go('/pay-account');
              },
            ),
          ],
        ),
      ),
      body: child,
    );
  }
}
