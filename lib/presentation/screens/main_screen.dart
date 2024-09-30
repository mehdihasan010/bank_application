import 'package:bank_application/presentation/screens/chart_screen.dart';
import 'package:bank_application/presentation/screens/home_screen.dart';
import 'package:bank_application/presentation/screens/profile_screen.dart';
//import 'package:bank_application/presentation/screens/wallet_screen.dart';
import 'package:bank_application/presentation/screens/wallet_screen_copy.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // List of widget pages corresponding to each bottom navigation item
  final List<Widget> _pages = [
    const HomeScreen(),
    const ChartScreen(),
    const WalletScreen2(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              // borderRadius: BorderRadius.only(
              //     topRight: Radius.circular(30), topLeft: Radius.circular(30)),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black38, spreadRadius: 0, blurRadius: 10),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),

              /* only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ), */
              child: NavigationBar(
                shadowColor: Colors.grey,
                elevation: 4,
                selectedIndex: _selectedIndex,
                onDestinationSelected: (int index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                destinations: const [
                  NavigationDestination(
                    icon: Icon(Iconsax.home),
                    label: 'Home',
                  ),
                  NavigationDestination(
                    icon: Icon(Iconsax.chart),
                    label: 'History',
                  ),
                  NavigationDestination(
                    icon: Icon(Iconsax.wallet),
                    label: 'Wallet',
                  ),
                  NavigationDestination(
                    icon: Icon(Iconsax.profile_circle),
                    label: 'Profile',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
