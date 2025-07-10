import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:network_test/features/account_management/account_model.dart';

final myIDAccountProvider = StateProvider((ref) => MyIDAccount());
