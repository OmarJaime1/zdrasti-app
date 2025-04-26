import 'package:flutter/material.dart';
import 'package:zdrasti_flutter/models/user.dart' as local;
import 'package:zdrasti_flutter/screens/tabs/dashboard_tab.dart';
import 'package:zdrasti_flutter/screens/tabs/lessons_tab.dart';
import 'package:zdrasti_flutter/screens/tabs/chat_tab.dart';
import 'package:zdrasti_flutter/screens/tabs/shadow_booster_tab.dart';
import 'package:zdrasti_flutter/screens/tabs/profile_tab.dart';

class ZdrastiShell extends StatefulWidget {
  final local.User user;

  const ZdrastiShell({super.key, required this.user});

  @override
  State<ZdrastiShell> createState() => _ZdrastiShellState();
}

class _ZdrastiShellState extends State<ZdrastiShell> {
  int _selectedIndex = 0;

  late final List<Widget> _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = [
      DashboardTab(user: widget.user),
      LessonsTab(user: widget.user),
      const ChatTab(),
      const ShadowBoosterTab(),
      ProfileTab(user: widget.user),
    ];
  }

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Lessons'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.flash_on), label: 'Review'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
