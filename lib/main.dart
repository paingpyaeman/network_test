import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'features/theme/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final savedTheme = prefs.getString('themeMode');
  final initialThemeMode = ThemeMode.values.firstWhere(
    (e) => e.name == savedTheme,
    orElse: () => ThemeMode.light,
  );

  runApp(
    ProviderScope(
      overrides: [themeModeProvider.overrideWith((ref) => initialThemeMode)],
      child: const MyApp(),
    ),
  );
}
