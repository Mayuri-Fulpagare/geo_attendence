import 'package:flutter/material.dart';
import '../screens/dashboard_page.dart';
import '../screens/attendance_page.dart';
import '../screens/leaves_page.dart';
import '../screens/history_page.dart';

class BottomNav extends StatefulWidget {
  final String userId; // ✅ Step 1: Accept userId in the constructor

  const BottomNav({Key? key, required this.userId}) : super(key: key); // ✅ Step 2: Mark it required

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _selectedIndex = 0;

  late final List<Widget> _screens; // ✅ Declare first, initialize in initState

  @override
  void initState() {
    super.initState();
    _screens = [
      const DashboardPage(),
      AttendancePage(userId: widget.userId), // ✅ Pass userId correctly here
      LeavesPage(),
      HistoryPage(userId: widget.userId),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fingerprint),
            label: 'Attendance',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Leaves',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
      ),
    );
  }
}
