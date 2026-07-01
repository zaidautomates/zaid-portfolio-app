import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../home/home_screen.dart';
import '../profile/profile_screen.dart';
import '../projects/projects_screen.dart';
import '../contact/contact_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  void _selectTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(
        onContactTap: () => _selectTab(3),
        onProjectsTap: () => _selectTab(2),
      ),
      const ProfileScreen(),
      const ProjectsScreen(),
      const ContactScreen(),
    ];

    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
          child: Container(
            decoration: BoxDecoration(
              color: context.navFill,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: context.cardBorder),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(
                    context.isDarkPortfolio ? 0.32 : 0.12,
                  ),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: NavigationBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              selectedIndex: _currentIndex,
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              indicatorColor: AppColors.purple.withOpacity(0.28),
              surfaceTintColor: Colors.transparent,
              onDestinationSelected: _selectTab,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_rounded),
                  selectedIcon: Icon(Icons.home_rounded),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline_rounded),
                  selectedIcon: Icon(Icons.person_rounded),
                  label: 'Profile',
                ),
                NavigationDestination(
                  icon: Icon(Icons.work_outline_rounded),
                  selectedIcon: Icon(Icons.work_rounded),
                  label: 'Projects',
                ),
                NavigationDestination(
                  icon: Icon(Icons.mail_outline_rounded),
                  selectedIcon: Icon(Icons.mail_rounded),
                  label: 'Contact',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
