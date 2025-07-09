import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:network_test/core/network/api_provider.dart';
import 'package:network_test/features/auth/auth_provider.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  Future<void> _checkTokenAndNavigate(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final user = ref.read(currentUserProvider);

    if (user == null) {
      context.go('/login');
      return;
    }

    try {
      final api = ref.read(apiServiceProvider);
      final response = await api.get(
        "/api/auth/profile",
        queryParams: {"username": user.username},
        headers: {'Authorization': 'Bearer ${user.token}'},
      );
      print("Response: $response");

      context.go("/account");
    } catch (e) {
      print("Check token failed");
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future.microtask(() => _checkTokenAndNavigate(context, ref));

    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
