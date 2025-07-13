import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:network_test/features/account_management/account_provider.dart';
import 'add_account/screen.dart';
import 'list_accounts/screen.dart';

class AccountScreen extends ConsumerStatefulWidget {
  const AccountScreen({super.key});

  @override
  ConsumerState<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends ConsumerState<AccountScreen> {
  static final List<Widget> _pages = <Widget>[
    AddAccountScreen(),
    ListAccountsScreen(),
  ];

  void _onItemTapped(int index) {
    ref.read(currentIndexProvider.notifier).state = index;
  }

  @override
  Widget build(BuildContext context) {
    var currentIndex = ref.watch(currentIndexProvider);
    return Scaffold(
      body: _pages.elementAt(currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.manage_accounts),
            label: 'Manage Account',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Account List',
          ),
        ],
        currentIndex: currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
