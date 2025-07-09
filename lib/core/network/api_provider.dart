// lib/core/network/api_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api_service.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService(baseUrl: 'https://solo-dev-zero.lol:3003');
});
