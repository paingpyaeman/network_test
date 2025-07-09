import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:network_test/widgets/widget_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../features/theme/theme_provider.dart';
import '../features/auth/auth_provider.dart';

class AppScaffold extends ConsumerWidget {
  final Widget child;
  const AppScaffold({super.key, required this.child});

  Future<void> _logout(WidgetRef ref, BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    // Clean the saved user
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    ref.read(currentUserProvider.notifier).state = null;
    if (context.mounted) {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final currentMenu = ref.watch(currentMenuProvider);
    final isDark = themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riverpod App'),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => toggleTheme(ref),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: () => _logout(ref, context),
            tooltip: 'Logout',
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
              title: Text(
                'Account Management',
                style: TextStyle(
                  fontWeight: currentMenu == 0
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
              onTap: () {
                ref.read(currentMenuProvider.notifier).state = 0;
                Navigator.pop(context);
                context.go('/account');
              },
            ),
            ListTile(
              title: Text(
                'Pay Account',
                style: TextStyle(
                  fontWeight: currentMenu == 1
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
              onTap: () {
                ref.read(currentMenuProvider.notifier).state = 1;
                Navigator.pop(context);
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
