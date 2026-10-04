import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'history_screen.dart';
import 'insights_screen.dart';

class AppNavigation extends StatefulWidget {
  const AppNavigation({super.key});

  @override
  State<AppNavigation> createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation> {
  int selectedIndex = 0;

   final List<Widget> screens = const [
    HomeScreen(),
    HistoryScreen(),
    InsightsScreen(),
  ];
  void changeScreen(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: screens,
      ),

      bottomNavigationBar: Container(
        height: 72,
        decoration: const BoxDecoration(
          color: Color(0xFFF7F7F5),
          border: Border(
            top: BorderSide(
              color: Color(0xFFE6E7E4),
            ),
          ),
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              icon: Icons.today_outlined,
              label: 'Today',
              index: 0,
            ),

            _buildNavItem(
              icon: Icons.calendar_today_outlined,
              label: 'History',
              index: 1,
            ),

            _buildNavItem(
              icon: Icons.insights_outlined,
              label: 'Insights',
              index: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final bool selected = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        changeScreen(index);
      },

      child: SizedBox(
        width: 65,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 21,
              color: selected
                  ? const Color(0xFF3F6B63)
                  : const Color(0xFF9AA09C),
            ),

            const SizedBox(height: 4),

            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight:
                    selected ? FontWeight.w600 : FontWeight.w400,
                color: selected
                    ? const Color(0xFF3F6B63)
                    : const Color(0xFF9AA09C),
              ),
            ),
          ],
        ),
      ),
    );
  }


}