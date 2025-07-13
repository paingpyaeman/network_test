import 'dart:convert';

import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:network_test/core/exceptions/api_failure_exception.dart';
import 'package:network_test/core/exceptions/auth_failure_exception.dart';
import 'package:network_test/core/network/api.dart';
import 'package:network_test/core/network/auth_api.dart';
import 'package:network_test/core/utils/constants.dart';
import 'package:network_test/core/utils/dialog_utils.dart';
import 'package:network_test/core/utils/loader.dart';
import 'package:network_test/core/utils/util.dart';
import 'package:network_test/features/account_management/account_model.dart';
import 'package:network_test/features/account_management/account_provider.dart';
import 'package:network_test/features/auth/auth_provider.dart';
import 'package:network_test/features/auth/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ListAccountsScreen extends ConsumerStatefulWidget {
  const ListAccountsScreen({super.key});

  @override
  ConsumerState<ListAccountsScreen> createState() => _ListAccountsScreenState();
}

enum BatchAction {
  networkTest,
  dailyQuest,
  refreshPoints,
  exchangePoints,
  delete,
}

class _ListAccountsScreenState extends ConsumerState<ListAccountsScreen> {
  // Global variables
  Logger logger = Logger();
  User? user;
  BatchAction currentBatchAction = BatchAction.networkTest;
  // List<NetworkAccount> allNetworkAccounts = [];
  List<NetworkAccount> filteredNetworkAccounts = [];
  // DateTimeRange? selectedDateRange;
  // int minPoints = 0;
  // int maxPoints = 1000000;
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    user = ref.watch(currentUserProvider);
    // var allNetworkAccounts = ref.watch(allNetworkAccountsProvider);
    filteredNetworkAccounts = ref.watch(filteredNetworkAccountsProvider);
    var showExpired = ref.watch(showExpiredProvider);
    var selectedDateRange = ref.watch(dateTimeRangeProvider);
    // var minPoints = ref.watch(minPointsProvider);
    // var maxPoints = ref.watch(maxPointsProvider);
    final NetworkAccountDataSource dataSource = NetworkAccountDataSource(
      accounts: filteredNetworkAccounts,
    );

    var sortedColumn = ref.read(sortedColumnProvider);
    var sortDirection = ref.read(sortDirectionProvider);

    if (sortedColumn != null && sortDirection != null) {
      dataSource.sortedColumns.add(
        SortColumnDetails(name: sortedColumn, sortDirection: sortDirection),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(width: 1, color: Colors.deepPurple),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    alignment: AlignmentDirectional.center,
                    borderRadius: BorderRadius.circular(16),
                    value: currentBatchAction,
                    items: const [
                      DropdownMenuItem(
                        value: BatchAction.networkTest,
                        child: Row(
                          children: [
                            Icon(Icons.speed),
                            SizedBox(width: 8),
                            Text("Network Test"),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: BatchAction.dailyQuest,
                        child: Row(
                          children: [
                            Icon(Icons.calendar_month),
                            SizedBox(width: 8),
                            Text("Daily Quest"),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: BatchAction.refreshPoints,
                        child: Row(
                          children: [
                            Icon(Icons.sync),
                            SizedBox(width: 8),
                            Text("Refresh Points"),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: BatchAction.exchangePoints,
                        child: Row(
                          children: [
                            Icon(Icons.currency_exchange),
                            SizedBox(width: 8),
                            Text("Exchange Points"),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: BatchAction.delete,
                        child: Row(
                          children: [
                            Icon(Icons.delete),
                            SizedBox(width: 8),
                            Text("Delete"),
                          ],
                        ),
                      ),
                    ],
                    onChanged: (selectedValue) {
                      setState(() {
                        currentBatchAction = selectedValue!;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Batch action button
              ElevatedButton(
                onPressed: () async {
                  handleBatchAction(currentBatchAction);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 28,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  children: [
                    const Text(
                      "RUN",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 4),
                    Text("(${filteredNetworkAccounts.length.toString()})"),
                  ],
                ),
              ),
            ],
          ),
        ),
        // FILTER START
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 250,
                    child: TextField(
                      onChanged: _searchPhoneNumber,
                      controller: _searchController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        prefixText: "09",
                        prefixIcon: Icon(Icons.search),
                        labelText: 'Phone number',
                        hintText: 'XXXXXXXXX',
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () async {
                      showRangeDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Points",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () async {
                      var dateTimeRange = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(3000),
                        initialDateRange: selectedDateRange,
                      );

                      if (dateTimeRange != null) {
                        logger.i(
                          "Start: ${dateTimeRange.start}, End: ${dateTimeRange.end}",
                        );
                        ref.read(dateTimeRangeProvider.notifier).state =
                            dateTimeRange;
                        filter();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Date",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _clearFilters,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Clear Filters",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Switch(
                    value: showExpired,
                    onChanged: (val) {
                      ref.read(showExpiredProvider.notifier).state = val;
                      filter();
                    },
                  ),
                  const Text("Expired"),
                ],
              ),
            ),
          ),
        ),
        // FILTER END
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              await refreshNetworkAccounts();
            },
            child: SfDataGrid(
              source: dataSource,
              allowSorting: true,
              columnWidthMode: ColumnWidthMode.auto,
              gridLinesVisibility: GridLinesVisibility.both,
              headerGridLinesVisibility: GridLinesVisibility.both,
              onColumnSortChanged: (newSortedColumn, oldSortedColumn) {
                ref.read(sortedColumnProvider.notifier).state =
                    newSortedColumn?.name;
                ref.read(sortDirectionProvider.notifier).state =
                    newSortedColumn?.sortDirection;
              },
              onCellTap: (details) {
                logger.i(details.rowColumnIndex.rowIndex);

                if (details.rowColumnIndex.rowIndex > 0) {
                  final dataRow = dataSource
                      .effectiveRows[details.rowColumnIndex.rowIndex - 1];
                  final netAccId = dataRow
                      .getCells()
                      .firstWhere((cell) => cell.columnName == 'id')
                      .value;

                  logger.i("acc: $netAccId");
                  final networkTestAccount = filteredNetworkAccounts.firstWhere(
                    (element) => element.id == netAccId,
                  );

                  _showMenuOptions(networkTestAccount);
                }
              },
              allowTriStateSorting: true,
              columns: [
                GridColumn(
                  columnName: 'id', // hidden column
                  visible: false,
                  label: Container(),
                ),
                GridColumn(
                  columnName: 'No',
                  label: Container(
                    padding: const EdgeInsets.all(8.0),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'No',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  columnWidthMode: ColumnWidthMode.auto,
                  allowFiltering: false,
                ),
                GridColumn(
                  columnName: 'Phone Number',
                  label: Container(
                    padding: const EdgeInsets.all(8.0),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Phone Number',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                GridColumn(
                  columnName: 'Loyalty Points',
                  label: Container(
                    padding: const EdgeInsets.all(8.0),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Loyalty Points',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                GridColumn(
                  columnName: 'Added Date',
                  label: Container(
                    padding: const EdgeInsets.all(8.0),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Added Date',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Handler functions
  void handleBatchAction(BatchAction currentBatchAction) async {}

  Future refreshNetworkAccounts() async {
    try {
      Loader.start(context);
      var userId = user?.id;
      var authToken = user?.token;
      if (userId == null || authToken == null || authToken.isEmpty) {
        throw AuthFailureException("Please login");
      }

      var response = await getAllAccountsFromDB(userId, authToken);

      if (response.statusCode != 200) {
        throw ApiFailureException("Failed to fetch network test accounts");
      }

      var list = jsonDecode(response.body);

      logger.i("list: ${list.length}");

      List<NetworkAccount> networkAccounts = [];
      if (list.length > 0) {
        for (var accountMap in list) {
          NetworkAccount na = NetworkAccount(id: accountMap['id']);
          na.phoneNumber = accountMap['phoneNumber'] as String;
          na.accessToken = accountMap['accessToken'] as String;
          na.isExpired = accountMap['isExpired'] as bool;
          na.loyaltyPoints = accountMap['loyaltyPoints'];
          na.lastUpdated = DateTime.fromMillisecondsSinceEpoch(
            accountMap['updatedAt'],
          );
          na.lastAuthenticated = DateTime.fromMillisecondsSinceEpoch(
            accountMap['lastAuthenticatedAt'],
          );
          na.lastRunDate = DateTime.fromMillisecondsSinceEpoch(
            accountMap['createdAt'],
          );
          networkAccounts.add(na);
        }

        logger.i("networkAccounts: ${networkAccounts.length}");
      } else {
        Fluttertoast.showToast(
          msg: 'Please add some network test numbers.',
          toastLength: Toast.LENGTH_SHORT,
          textColor: Colors.amber,
        );
      }

      ref.read(allNetworkAccountsProvider.notifier).state = networkAccounts;
      filter();
    } on AuthFailureException catch (e) {
      Fluttertoast.showToast(
        msg: e.msg,
        toastLength: Toast.LENGTH_SHORT,
        textColor: Colors.red,
      );
      Loader.stop(context);
      context.pushReplacement("/login");
    } on ApiFailureException catch (e) {
      Fluttertoast.showToast(
        msg: e.msg,
        toastLength: Toast.LENGTH_SHORT,
        textColor: Colors.red,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Unknown error during loading network accounts.',
        toastLength: Toast.LENGTH_SHORT,
        textColor: Colors.red,
      );
      debugPrint(e.toString());
    } finally {
      Loader.stop(context);
    }
  }

  void showRangeDialog(context) {
    showDialog(
      context: context,
      builder: (context) {
        final minController = TextEditingController(
          text: ref.read(minPointsProvider).toString(),
        );
        final maxController = TextEditingController(
          text: ref.read(maxPointsProvider).toString(),
        );
        return AlertDialog(
          title: const Text('Enter Range'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: minController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Minimum Points'),
              ),
              TextField(
                controller: maxController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Maximum Points'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                int min = int.tryParse(minController.text) ?? 0;
                int max = int.tryParse(maxController.text) ?? 0;
                if (min <= max) {
                  ref.read(minPointsProvider.notifier).state = min;
                  ref.read(maxPointsProvider.notifier).state = max;
                  filter();
                  Navigator.pop(context);
                } else {
                  // Show error message (optional)
                  Fluttertoast.showToast(
                    msg:
                        "Minimum value should be less than or equal to Maximum value",
                    toastLength: Toast.LENGTH_SHORT,
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showMenuOptions(NetworkAccount netAccount) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Select action'),
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  SimpleDialogOption(
                    onPressed: () async {
                      Navigator.pop(
                        context,
                      ); // Close dialog and return selection

                      final ma = MyIDAccount(
                        accessToken: netAccount.accessToken,
                        phoneNumber: netAccount.phoneNumber,
                      );

                      ref.read(myIDAccountProvider.notifier).state = ma;

                      final prefs = await SharedPreferences.getInstance();
                      prefs.setString(
                        AuthStrings.myIDAccountKey,
                        jsonEncode(ma.toJson()),
                      );

                      ref.read(currentIndexProvider.notifier).state = 0;
                    },
                    child: const SizedBox(
                      width: double.infinity,
                      child: Row(
                        children: [
                          Icon(Icons.loyalty),
                          SizedBox(width: 8),
                          Text("Manage", style: TextStyle(fontSize: 15)),
                        ],
                      ),
                    ),
                  ),
                  SimpleDialogOption(
                    onPressed: () async {
                      Navigator.pop(
                        context,
                      ); // Close dialog and return selection
                      Fluttertoast.showToast(
                        msg: "Please log in.",
                        toastLength: Toast.LENGTH_SHORT,
                      );
                      await handleReLogin(netAccount);
                    },
                    child: const SizedBox(
                      width: double.infinity,
                      child: Row(
                        children: [
                          Icon(Icons.login),
                          SizedBox(width: 8),
                          Text("Login", style: TextStyle(fontSize: 15)),
                        ],
                      ),
                    ),
                  ),
                  SimpleDialogOption(
                    onPressed: () async {
                      Navigator.pop(
                        context,
                      ); // Close dialog and return selection
                      if (await confirm(
                        context,
                        title: const Text('Confirm'),
                        content: const Text(
                          'Would you like to remove the account?',
                        ),
                        textOK: const Text('Remove'),
                        textCancel: const Text('Cancel'),
                      )) {
                        removeAccountFromNetwork(netAccount);
                      }
                    },
                    child: const SizedBox(
                      width: double.infinity,
                      child: Row(
                        children: [
                          Icon(Icons.delete),
                          SizedBox(width: 8),
                          Text("Remove", style: TextStyle(fontSize: 15)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    ).then((value) => debugPrint(value));
  }

  Future handleReLogin(NetworkAccount netAcc) async {
    try {
      Loader.start(context);
      var phoneNumber = netAcc.phoneNumber;
      // navigate user to login page if the user is no longer authenticated
      await checkAuthentication(user, AuthStrings.networkTestRole);
      final prefs = await SharedPreferences.getInstance();

      logger.i("phone: $phoneNumber");

      // request otp
      var otp = {};
      otp = await requestOTP(phoneNumber);
      if (otp['errorCode'] == null) {
        throw ApiFailureException("Failed to get OTP.");
      }

      String? otpCode = "";
      otpCode = await openInputDialog(context, "Enter OTP", "OTP", "otp");
      if (otpCode == null || otpCode.isEmpty || !isNumeric(otpCode)) {
        throw ApiFailureException("OTP is invalid.");
      }

      // authenticate
      var authResponse = {};
      authResponse = await authenticate(phoneNumber, otpCode);
      if (authResponse['result'] == null ||
          authResponse['result']['access_token'] == null) {
        throw ApiFailureException("Failed to login.");
      }

      String? accessToken = authResponse['result']['access_token'];
      if (accessToken == null || accessToken.isEmpty) {
        throw ApiFailureException("Failed to login.");
      }

      String? refreshToken = authResponse['result']['refresh_token'];
      if (refreshToken == null || refreshToken.isEmpty) {
        throw ApiFailureException("Failed to login.");
      }

      MyIDAccount ma = MyIDAccount(
        phoneNumber: phoneNumber,
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
      ref.read(myIDAccountProvider.notifier).state = ma;

      // save to local storage
      await prefs.setString(
        AuthStrings.myIDAccountKey,
        jsonEncode(ma.toJson()),
      );

      var userId = user?.id;
      var authToken = user?.token;

      if (userId == null || authToken == null) {
        throw AuthFailureException("Please login again");
      }

      int points;
      if (netAcc.loyaltyPoints == 0) {
        points = await loadPoints(phoneNumber, accessToken);
      } else {
        points = netAcc.loyaltyPoints;
      }

      logger.i("Points: $points");
      var response = await saveNetworkTestAccount(
        phoneNumber: phoneNumber,
        accessToken: accessToken,
        loyaltyPoints: points,
        userId: userId,
        authToken: authToken,
      );

      var respJson = utf8JsonDecode(response);
      logger.i("respJson: $respJson");

      if (response.statusCode != 200) {
        throw ApiFailureException("Failed to save network test account.");
      }

      // Add new network account to list
      NetworkAccount na = NetworkAccount(id: respJson['id']);
      na.phoneNumber = respJson['phoneNumber'] as String;
      na.accessToken = respJson['accessToken'] as String;
      na.isExpired = respJson['isExpired'] as bool;
      na.loyaltyPoints = respJson['loyaltyPoints'];
      na.lastUpdated = DateTime.fromMillisecondsSinceEpoch(
        respJson['updatedAt'],
      );
      na.lastAuthenticated = DateTime.fromMillisecondsSinceEpoch(
        respJson['lastAuthenticatedAt'],
      );
      na.lastRunDate = DateTime.fromMillisecondsSinceEpoch(
        respJson['createdAt'],
      );

      var allAccounts = ref.read(allNetworkAccountsProvider);
      allAccounts.removeWhere((ntAcc) => ntAcc.id == na.id);
      allAccounts.add(na);
      ref.read(allNetworkAccountsProvider.notifier).state = [...allAccounts];

      filter();

      Fluttertoast.showToast(msg: "SUCCESS", toastLength: Toast.LENGTH_SHORT);
    } on AuthFailureException catch (e) {
      Fluttertoast.showToast(
        msg: e.msg,
        toastLength: Toast.LENGTH_SHORT,
        textColor: Colors.red,
      );
      Loader.stop(context);
      Navigator.of(context).pushReplacementNamed("/login");
    } on ApiFailureException catch (e) {
      Fluttertoast.showToast(
        msg: e.msg,
        toastLength: Toast.LENGTH_SHORT,
        textColor: Colors.red,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to log in.",
        toastLength: Toast.LENGTH_SHORT,
        textColor: Colors.red,
      );
    } finally {
      Loader.stop(context);
    }
  }

  void removeAccountFromNetwork(NetworkAccount netAccount) async {
    Loader.start(context);
    try {
      logger.i(netAccount.id);
      List<int> ids = [netAccount.id];
      await deleteFilteredAccounts(ids);
      var allNetworkAccounts = ref.read(allNetworkAccountsProvider);
      allNetworkAccounts.remove(netAccount);
      ref.read(allNetworkAccountsProvider.notifier).state = [
        ...allNetworkAccounts,
      ];
      filter();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      Loader.stop(context);
    }
  }

  Future<int> loadPoints(String phoneNumber, String accessToken) async {
    var points = 0;
    var pointDetail = await getPointDetailsRank(phoneNumber, accessToken);
    if (pointDetail["result"] != null) {
      points = int.parse(pointDetail["result"]["exchangeBalance"]);
    }

    return points;
  }

  // FILTER METHODS START
  void filter() {
    logger.i("filter() start");
    var phoneNumber = _searchController.text;
    filterPoint();
    filterPhoneNumber(phoneNumber);
    var selectedDateRange = ref.read(dateTimeRangeProvider);
    if (selectedDateRange != null) {
      filterDate(selectedDateRange);
    }
    ref.read(filteredNetworkAccountsProvider.notifier).state = [
      ...filteredNetworkAccounts,
    ];
    logger.i("filter() end");
  }

  void filterPoint() {
    logger.i("filterPoint() start");
    filteredNetworkAccounts = ref.read(allNetworkAccountsProvider).where((acc) {
      bool rangeFiltered =
          acc.loyaltyPoints >= ref.read(minPointsProvider) &&
          acc.loyaltyPoints <= ref.read(maxPointsProvider);
      return acc.isExpired == ref.read(showExpiredProvider) && rangeFiltered;
    }).toList();
    logger.i("filterPoint() end");
  }

  void _searchPhoneNumber(String phoneNumber) {
    filter();
  }

  void filterPhoneNumber(String phoneNumber) {
    filteredNetworkAccounts = filteredNetworkAccounts
        .where((element) => element.phoneNumber.startsWith("09$phoneNumber"))
        .toList();
  }

  void filterDate(DateTimeRange selectedDateRange) {
    filteredNetworkAccounts = filteredNetworkAccounts.where((element) {
      var addedDate = stripTime(element.lastRunDate!);

      return ((addedDate.isAfter(selectedDateRange.start) ||
                  addedDate.isAtSameMomentAs(selectedDateRange.start)) &&
              (addedDate.isBefore(selectedDateRange.end)) ||
          addedDate.isAtSameMomentAs(selectedDateRange.end));
    }).toList();
  }

  void _clearFilters() {
    _searchController.clear();
    ref.read(minPointsProvider.notifier).state = 0;
    ref.read(maxPointsProvider.notifier).state = 1000000;
    ref.read(dateTimeRangeProvider.notifier).state = null;

    filter();
  }

  // FILTER METHODS END
}
