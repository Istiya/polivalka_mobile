import 'package:flutter/material.dart';
import 'package:polivalka/pages/plants_page.dart';

import 'account_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          labelTextStyle:  WidgetStateProperty.resolveWith<TextStyle>(
                (Set<WidgetState> states) => states.contains(WidgetState.selected)
                ? const TextStyle(color: Colors.white)
                : const TextStyle(color: Colors.black),
          ),
        ),
        child: NavigationBar(
          backgroundColor: Color.fromRGBO(149, 188, 143, 1),
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          indicatorColor: Color.fromRGBO(248, 255, 248, 1),
          selectedIndex: currentPageIndex,
          destinations: const <Widget>[
            NavigationDestination(
              selectedIcon: Icon(Icons.account_circle),
              icon: Icon(Icons.account_circle_outlined),
              label: 'Account',
            ),
            NavigationDestination(
              icon: Icon(Icons.grass),
              label: 'Plants',
            ),
          ],
        ),
      ),
      body: <Widget> [
        AccountPage(),
        PlantsPage()
      ][currentPageIndex]
    );
  }
}
