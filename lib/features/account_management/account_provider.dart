import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:network_test/features/account_management/account_model.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

final currentIndexProvider = StateProvider((ref) => 0);

final myIDAccountProvider = StateProvider((ref) => MyIDAccount());

final allNetworkAccountsProvider = StateProvider<List<NetworkAccount>>(
  (ref) => [],
);
final filteredNetworkAccountsProvider = StateProvider<List<NetworkAccount>>(
  (ref) => [],
);

final sortedColumnProvider = StateProvider<String?>((ref) => null);
final sortDirectionProvider = StateProvider<DataGridSortDirection?>(
  (ref) => null,
);

// Search and filtering
final minPointsProvider = StateProvider((ref) => 0);
final maxPointsProvider = StateProvider((ref) => 1000000);
final dateTimeRangeProvider = StateProvider<DateTimeRange?>((ref) => null);
final showExpiredProvider = StateProvider((ref) => false);
//DateTimeRange? selectedDateRange;
