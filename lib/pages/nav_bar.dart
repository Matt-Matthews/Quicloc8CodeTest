// ignore_for_file: use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';
import 'package:myapp/pages/home.dart';
import 'package:myapp/pages/messages.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _index = 0;
  final List<Widget> _pages = [const HomePage(), const Messages()];

  @override
  Widget build(BuildContext context) {
    void onTappedBar(int index) {
      setState(() {
        _index = index;
      });
    }

    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.location_pin), label: 'Map'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Messages')
        ],
        onTap: onTappedBar,
        currentIndex: _index,
        elevation: 1.5,
        iconSize: 30.0,
        showUnselectedLabels: true,
        showSelectedLabels: true,
        backgroundColor: const Color(0xfffffffff),
        unselectedIconTheme:
            IconThemeData(color: Theme.of(context).colorScheme.secondary),
        selectedIconTheme:
            IconThemeData(color: Theme.of(context).colorScheme.primary),
      ),
    );
  }
}
