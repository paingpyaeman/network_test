import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'user_model.dart';

final currentUserProvider = StateProvider<User?>((ref) => null);
