import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:network_test/core/utils/constants.dart';
import 'package:network_test/features/account_management/account_model.dart';
import 'package:network_test/features/account_management/account_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'features/theme/theme_provider.dart';
import 'features/auth/auth_provider.dart';
import 'features/auth/user_model.dart';
import 'dart:convert';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final savedTheme = prefs.getString('themeMode');
  final savedUserJson = prefs.getString('user');
  final savedMyIDAccount = prefs.getString(AuthStrings.myIDAccountKey);

  final initialThemeMode = ThemeMode.values.firstWhere(
    (e) => e.name == savedTheme,
    orElse: () => ThemeMode.light,
  );
  final user = savedUserJson != null
      ? User.fromJson(jsonDecode(savedUserJson))
      : null;

  final myIDAccount = savedMyIDAccount != null
      ? MyIDAccount.fromJson(jsonDecode(savedMyIDAccount))
      : MyIDAccount();

  runApp(
    ProviderScope(
      overrides: [
        themeModeProvider.overrideWith((ref) => initialThemeMode),
        currentUserProvider.overrideWith((ref) => user),
        myIDAccountProvider.overrideWith((ref) => myIDAccount),
      ],
      child: const MyApp(),
    ),
  );
}
