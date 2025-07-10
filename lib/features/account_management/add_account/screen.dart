import 'dart:convert';

import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:loading_progress/loading_progress.dart';
import 'package:network_test/core/exceptions/api_failure_exception.dart';
import 'package:network_test/core/exceptions/auth_failure_exception.dart';
import 'package:network_test/core/network/api.dart';
import 'package:network_test/core/network/auth_api.dart';
import 'package:network_test/core/utils/constants.dart';
import 'package:network_test/core/utils/util.dart';
import 'package:network_test/features/account_management/account_model.dart';
import 'package:network_test/features/account_management/account_provider.dart';
import 'package:network_test/features/auth/auth_provider.dart';
import 'package:network_test/features/auth/user_model.dart';
import 'package:network_test/widgets/quest_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum PurchaseMethod { bill, pay }

class AddAccountScreen extends ConsumerStatefulWidget {
  const AddAccountScreen({super.key});

  @override
  ConsumerState<AddAccountScreen> createState() => _AddAccountScreenState();
}

class _AddAccountScreenState extends ConsumerState<AddAccountScreen> {
  // Global variables
  var logger = Logger();

  final _phoneInputController = TextEditingController();

  bool _isLoadingAccountDetails = false;

  get handleNetworkTest => null;

  PurchaseMethod purchaseMethod = PurchaseMethod.bill;

  // will init later
  MyIDAccount myIDAccount = MyIDAccount();
  User? user;

  void initValues() {
    myIDAccount = ref.watch(myIDAccountProvider);
    user = ref.watch(currentUserProvider);
  }

  @override
  Widget build(BuildContext context) {
    initValues();

    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 28),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Phone Number:"),
                  Text(myIDAccount.phoneNumber),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 28),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Main Balance:"),
                  Text("${myIDAccount.mainBalance} Ks"),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 28),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Data:"),
                  Text("${myIDAccount.dataBalance} MB"),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 28),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Expire Date:"),
                  Text("${myIDAccount.dataExpireTime}"),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 28),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Voice:"),
                  Text("${myIDAccount.voiceBalance} min"),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 28),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Loyalty Points:"),
                  Text("${myIDAccount.loyaltyPoints} points"),
                ],
              ),
            ),
            // start of delete, exchange, refresh buttons
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 28),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red, size: 30),
                    onPressed: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Confirm'),
                          content: const Text(
                            'Would you like to remove the account?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text(
                                'Remove',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );

                      if (confirmed == true) {
                        removeAccount();
                      }
                    },
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _handleLoginRegister();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        showOptionDialog(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Exchange",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: _isLoadingAccountDetails
                        ? const CircularProgressIndicator()
                        : const Icon(Icons.refresh, size: 36),
                    onPressed: loadAccountDetails,
                  ),
                ],
              ),
            ),
            // end of delete, exchange, refresh buttons
            const SizedBox(height: 20),
            const Divider(
              height: 1.0,
              thickness: 0.5,
              color: Colors.deepPurple,
              indent: 20.0,
              endIndent: 20.0,
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                // Purchase method selection
                Padding(
                  padding: const EdgeInsets.only(left: 28),
                  child: SegmentedButton(
                    showSelectedIcon: true,
                    style: ButtonStyle(
                      padding: WidgetStateProperty.all(
                        const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 18,
                        ),
                      ),
                    ),
                    segments: const [
                      ButtonSegment(
                        value: PurchaseMethod.bill,
                        label: Text('Bill'),
                        icon: Icon(Icons.money),
                      ),
                      ButtonSegment(
                        value: PurchaseMethod.pay,
                        label: Text('Pay'),
                        icon: Icon(Icons.payment),
                      ),
                    ],
                    selected: <PurchaseMethod>{purchaseMethod},
                    onSelectionChanged: (newSelection) {
                      setState(() {
                        purchaseMethod = newSelection.first;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: ElevatedButton(
                      onPressed: () async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Confirm'),
                            content: const Text(
                              'Would you like to buy HL2 package for 200 Ks?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: const Text('Confirm'),
                              ),
                            ],
                          ),
                        );

                        if (confirmed == true) {
                          if (purchaseMethod == PurchaseMethod.bill) {
                            _buyNormalPack("HL2");
                          } else {
                            _buyPack("HL2", 200);
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Buy HL2",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: ElevatedButton(
                      onPressed: handleNetworkTest,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Add to Network Test",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(
              height: 1.0,
              thickness: 0.5,
              color: Colors.deepPurple,
              indent: 20.0,
              endIndent: 20.0,
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: ElevatedButton(
                      onPressed: linkOtherNumber,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Link Other",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: ElevatedButton(
                      onPressed: handleGrandQuest,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Grand Quest",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void removeAccount() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AuthStrings.myIDAccountKey);

    ref.read(myIDAccountProvider.notifier).state = MyIDAccount();
  }

  void showOptionDialog(BuildContext context) {
    final Map<String, String> exchangeOptions = {
      // '3,600 MB [1200 Points]': 'DATA_3600MB',
      '2,750 MB [1000 Points]': 'DATA_2750MB',
      '2,000 MB [800 Points]': 'DATA_2000MB',
      '1,350 MB [600 Points]': 'DATA_1350MB',
      '800 MB [400 Points]': 'DATA_800MB',
      '300 MB [200 Points]': 'DATA_300MB',
      '100 MB [100 Points]': 'DATA_100MB',
      '40 MB [50 Points]': 'DATA_40MB',
    };

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Select exchange option'),
          children: [
            SingleChildScrollView(
              child: Column(
                children: exchangeOptions.keys
                    .map(
                      (option) => SimpleDialogOption(
                        onPressed: () {
                          Navigator.pop(
                            context,
                            option,
                          ); // Close dialog and return selection
                        },
                        child: SizedBox(
                          width: double.infinity,
                          child: Text(option),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        );
      },
    ).then((selectedValue) async {
      // Handle selection result after dialog closes
      if (selectedValue != null) {
        if (await confirm(
          context,
          title: const Text('Confirm'),
          content: Text('Are you sure to exchange $selectedValue?'),
          textOK: const Text('OK'),
          textCancel: const Text('Cancel'),
        )) {
          try {
            startLoadingProgress();
            String? accessToken = myIDAccount.accessToken;
            String? phoneNumber = myIDAccount.phoneNumber;

            if (accessToken == null) {
              throw ApiFailureException("Login to exchange points.");
            }

            // navigate user to login page if the user is no longer authenticated
            await checkAuthentication(user, AuthStrings.networkTestRole);

            Map<String, dynamic> response = await exchangePoints(
              phoneNumber,
              accessToken,
              exchangeOptions[selectedValue]!,
            );

            logger.i("Exchange response: $response");

            if (response["errorCode"] != "00000") {
              throw ApiFailureException(response["message"]);
            }
            Fluttertoast.showToast(
              msg: response["message"],
              toastLength: Toast.LENGTH_SHORT,
            );
            loadAccountDetails();
          } on AuthFailureException catch (e) {
            Fluttertoast.showToast(
              msg: e.msg,
              toastLength: Toast.LENGTH_SHORT,
              textColor: Colors.red,
            );
            endLoadingProgress();
            context.pushReplacement("/login");
          } on ApiFailureException catch (e) {
            Fluttertoast.showToast(
              msg: e.msg,
              toastLength: Toast.LENGTH_SHORT,
              textColor: Colors.red,
            );
          } catch (e) {
            Fluttertoast.showToast(
              msg: "Failed to exchange points",
              toastLength: Toast.LENGTH_SHORT,
              textColor: Colors.red,
            );
          } finally {
            endLoadingProgress();
          }
        }
      }
    });
  }

  Future<void> handleGrandQuest() async {
    try {
      startLoadingProgress();
      // check myIDAccount
      var phoneNumber = myIDAccount.phoneNumber;
      var accessToken = myIDAccount.accessToken;
      if (phoneNumber.isEmpty) {
        throw ApiFailureException("Login first");
      }

      if (accessToken == null || accessToken.isEmpty) {
        throw ApiFailureException("Login first");
      }

      // navigate user to login page if the user is no longer authenticated
      await checkAuthentication(user, AuthStrings.networkTestRole);

      var infoResp = await getGrandQuestInfo(phoneNumber, accessToken);
      debugPrint(infoResp.toString());
      if (infoResp["success"] != true) {
        throw ApiFailureException(
          "Failed to get quest info: ${infoResp['message']}",
        );
      }

      var mainResponse = infoResp["result"]["mainScreenResponse"];

      // check if user bought HL2
      if (mainResponse["hl2package"]["isComplete"] == false) {
        throw ApiFailureException(
          "Failed to get quest info: not bought HL2 yet",
        );
      }

      // Already received the grand quest
      var grand = mainResponse["grand"];
      if (grand["isComplete"] == true) {
        Fluttertoast.showToast(
          msg: "Already claimed grand quest",
          toastLength: Toast.LENGTH_SHORT,
          textColor: Colors.green,
        );
        return;
      }

      // var miniQuests = mainResponse["miniQuest"];

      // for (var miniQuest in miniQuests) {
      //   logger.i(miniQuest["title"]);
      //   logger.i(miniQuest);
      // }

      await showDialog(
        context: context,
        builder: (_) => QuestDialog(
          myIDAccount: myIDAccount,
          daily: mainResponse['daily'],
          grand: mainResponse['grand'],
          miniQuests: mainResponse['miniQuest'],
        ),
      );
    } on AuthFailureException catch (e) {
      Fluttertoast.showToast(
        msg: e.msg,
        toastLength: Toast.LENGTH_SHORT,
        textColor: Colors.red,
      );
      endLoadingProgress();
      Navigator.of(context).pushReplacementNamed("/login");
    } on ApiFailureException catch (e) {
      Fluttertoast.showToast(
        msg: e.msg,
        toastLength: Toast.LENGTH_SHORT,
        textColor: Colors.red,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to claim grand quest",
        toastLength: Toast.LENGTH_SHORT,
        textColor: Colors.red,
      );
    } finally {
      endLoadingProgress();
    }
  }

  void linkOtherNumber() async {
    logger.i("linkOtherNumber Start");
    final pref = await SharedPreferences.getInstance();
    await pref.setString(
      AuthStrings.myIDAccountKey,
      jsonEncode(myIDAccount.toJson()),
    );
    logger.i("linkOtherNumber End");
  }

  List<int> loadings = [];

  void startLoadingProgress() {
    loadings.add(1);
    LoadingProgress.start(
      context,
      widget: Container(
        width: MediaQuery.of(context).size.width / 4,
        padding: EdgeInsets.all(MediaQuery.of(context).size.width / 13),
        child: const AspectRatio(
          aspectRatio: 1,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeCap: StrokeCap.round,
            strokeWidth: 8.0,
          ),
        ),
      ),
    );
  }

  void endLoadingProgress() {
    if (loadings.isNotEmpty) {
      LoadingProgress.stop(context);
      loadings.removeLast();
    }
  }

  void _handleLoginRegister() async {
    try {
      startLoadingProgress();
      // navigate user to login page if the user is no longer authenticated
      await checkAuthentication(user, AuthStrings.networkTestRole);

      String? phoneNumber = await openInputDialog(
        "Enter phone number",
        "Phone number",
        "phone",
      );
      if (phoneNumber == null ||
          phoneNumber.isEmpty ||
          !isNumeric(phoneNumber)) {
        throw ApiFailureException("Phone number is invalid.");
      }
      logger.i("phone: $phoneNumber");

      var accountExistence = await checkAccount(phoneNumber);
      logger.i("accountExistence: $accountExistence");

      if (accountExistence["errorCode"] != 200) {
        // account does not exist, create account
        // request for registration
        var reqRegResponse = await requestRegistration(phoneNumber);
        logger.i("reqRegResponse: $reqRegResponse");

        if (reqRegResponse["result"] == null ||
            reqRegResponse["result"]["reqId"] == null) {
          throw ApiFailureException("Registration Failed.");
        }
        String reqId = reqRegResponse["result"]["reqId"];

        // ask user for OTP
        String? otpCode = await openInputDialog("Enter OTP", "OTP", "otp");
        if (otpCode == null || otpCode.isEmpty || !isNumeric(otpCode)) {
          throw ApiFailureException("OTP is invalid.");
        }

        var confirmResponse = await confirmRegistration(
          phoneNumber,
          otpCode,
          reqId,
        );
        logger.i("confirmResponse: $confirmResponse");
        if (confirmResponse["errorCode"] != 200) {
          throw ApiFailureException("Failed to confirm registration.");
        }
        accountExistence["errorCode"] = 200;
      }

      // request otp
      var otp = {};
      otp = await requestOTP(phoneNumber);
      if (otp['errorCode'] == null) {
        throw ApiFailureException("Failed to get OTP.");
      }

      String? otpCode = "";
      otpCode = await openInputDialog("Enter OTP", "OTP", "otp");
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

      myIDAccount.phoneNumber = phoneNumber;
      myIDAccount.accessToken = accessToken;
      myIDAccount.refreshToken = refreshToken;
      ref.read(myIDAccountProvider.notifier).state = myIDAccount;

      Fluttertoast.showToast(msg: "SUCCESS", toastLength: Toast.LENGTH_SHORT);

      loadAccountDetails();
    } on AuthFailureException catch (e) {
      Fluttertoast.showToast(
        msg: e.msg,
        toastLength: Toast.LENGTH_SHORT,
        textColor: Colors.red,
      );
      endLoadingProgress();
      context.pushReplacement("/login");
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
      endLoadingProgress();
    }
  }

  Future<String?> openInputDialog(String title, String label, String type) {
    var hintText = "09XXXXXXXXX";
    if (type == "barcode") {
      hintText = "1234567890123456789";
    } else if (type == "otp") {
      hintText = "123456";
    }
    return showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: TextField(
          autofocus: true,
          controller: _phoneInputController,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: label,
            hintText: hintText,
          ),
          keyboardType: type == "phone"
              ? TextInputType.phone
              : TextInputType.number,
          onSubmitted: (_) => onInputSubmit(dialogContext),
        ),
        actions: [
          TextButton(
            onPressed: () {
              onInputSubmit(dialogContext);
            },
            child: const Text("Submit"),
          ),
        ],
      ),
    );
  }

  void onInputSubmit(BuildContext context) {
    Navigator.of(context).pop(_phoneInputController.text.trim());
    _phoneInputController.clear();
  }

  Future loadAccountDetails() async {
    setState(() {
      _isLoadingAccountDetails = true;
    });
    try {
      String? accessToken = myIDAccount.accessToken;
      String? phoneNumber = myIDAccount.phoneNumber;
      if (accessToken == null) {
        throw ApiFailureException("Login to see account balance.");
      } else {
        setState(() {
          myIDAccount.phoneNumber = phoneNumber;
        });

        // Fluttertoast.showToast(
        //   msg: "Loading account details",
        //   toastLength: Toast.LENGTH_SHORT,
        // );
        Map<String, dynamic> accountDetail = await getAccountDetails(
          phoneNumber,
          accessToken,
        );
        Map<String, dynamic> pointDetail = await getPointDetailsRank(
          phoneNumber,
          accessToken,
        );

        logger.i("accountDetail: $accountDetail");
        logger.i("pointDetail: $pointDetail");

        // Obtain account balance details
        if (accountDetail["result"] == null) {
          throw ApiFailureException("Failed to get account details.");
        }

        // Obtain point details
        if (pointDetail["errorCode"] == "00008") {
          throw ApiFailureException(pointDetail["message"]);
        }
        if (pointDetail["result"] == null) {
          throw ApiFailureException("Failed to get point details.");
        }
        logger.i(pointDetail);

        String accountId = accountDetail["result"][0]["subId"];
        var dataDetails = await getDataDetails(
          phoneNumber,
          accessToken,
          accountId,
        );
        if (dataDetails["result"] == null) {
          throw ApiFailureException("Failed to get account details.");
        }

        String? expireTime;
        var dataGroupDetails = dataDetails["result"]["accounts"][0]["details"];
        for (var dataGroupDetail in dataGroupDetails) {
          if (dataGroupDetail['balanceTypeId'] == 32) {
            logger.i(
              "${dataGroupDetail['balance']}: ${dataGroupDetail['expireTime']}",
            );
            expireTime = dataGroupDetail['expireTime'];
          }
        }

        setState(() {
          myIDAccount.phoneNumber = phoneNumber;
          myIDAccount.mainBalance =
              accountDetail["result"][0]["mainBalance"]["main"]["amount"];
          myIDAccount.voiceBalance =
              accountDetail["result"][0]["mainBalance"]["voice"]["amount"];
          myIDAccount.dataBalance =
              accountDetail["result"][0]["mainBalance"]["data"]["amount"];
          myIDAccount.dataExpireTime = expireTime;
          myIDAccount.loyaltyPoints = int.parse(
            pointDetail["result"]["exchangeBalance"],
          );
        });

        // Fluttertoast.showToast(
        //     msg: "Finished loading account details.",
        //     toastLength: Toast.LENGTH_SHORT);
      }
    } on ApiFailureException catch (e) {
      Fluttertoast.showToast(
        msg: e.msg,
        toastLength: Toast.LENGTH_SHORT,
        textColor: Colors.red,
      );
    } catch (e) {
      logger.e(e);
      Fluttertoast.showToast(
        msg: "Failed to load account details.",
        toastLength: Toast.LENGTH_SHORT,
        textColor: Colors.red,
      );
    } finally {
      setState(() {
        _isLoadingAccountDetails = false;
      });
    }
  }

  void _buyNormalPack(String s) {}

  void _buyPack(String s, int i) {}
}
