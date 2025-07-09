import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:network_test/features/schedule_management/add_schedule/screen.dart';
import 'package:network_test/features/schedule_management/list_schedules/screen.dart';

import 'features/account_management/screen.dart';
import 'features/auth/login_screen.dart';
import 'features/pay_account/screen.dart';
import 'splash_screen.dart';
import 'widgets/app_scaffold.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      ShellRoute(
        builder: (context, state, child) => AppScaffold(child: child),
        routes: [
          GoRoute(
            path: '/account',
            builder: (context, state) => const AccountScreen(),
          ),
          GoRoute(
            path: '/schedule-list',
            builder: (context, state) => const ScheduleListScreen(),
          ),

          GoRoute(
            path: '/pay-account',
            builder: (context, state) => const AddPayAccountScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/add-schedule',
        builder: (context, state) => const AddScheduleScreen(),
      ),
    ],
  );
});
