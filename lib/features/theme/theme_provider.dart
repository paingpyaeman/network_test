import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeModeProvider = StateProvider<ThemeMode>((ref) {
  return ThemeMode.system;
});

Future<void> toggleTheme(WidgetRef ref) async {
  final prefs = await SharedPreferences.getInstance();
  final current = ref.read(themeModeProvider);
  final newMode = current == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
  ref.read(themeModeProvider.notifier).state = newMode;
  await prefs.setString('themeMode', newMode.name);
}
