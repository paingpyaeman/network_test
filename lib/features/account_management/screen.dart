import 'package:flutter/material.dart';
import 'add_account/screen.dart';
import 'list_accounts/screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    AddAccountScreen(),
    ListAccountsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages.elementAt(_selectedIndex),
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
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
