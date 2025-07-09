import 'package:flutter/material.dart';
import 'package:network_test/features/account_management/account_model.dart';

enum PurchaseMethod { bill, pay }

class AddAccountScreen extends StatefulWidget {
  const AddAccountScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AddAccountScreenState();
}

class _AddAccountScreenState extends State<AddAccountScreen> {
  bool _isLoadingAccountDetails = false;

  get handleNetworkTest => null;

  get loadAccountDetails => null;

  final MyIDAccount myIDAccount = MyIDAccount();
  PurchaseMethod purchaseMethod = PurchaseMethod.bill;

  @override
  Widget build(BuildContext context) {
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

  void removeAccount() {}

  void showOptionDialog(BuildContext context) {}

  void handleGrandQuest() {}

  void linkOtherNumber() {}

  void _handleLoginRegister() {}

  void _buyNormalPack(String s) {}

  void _buyPack(String s, int i) {}
}
