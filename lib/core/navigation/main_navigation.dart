import 'package:flutter/material.dart';
import 'package:flutter_application_2/features/assessment/pages/assignment_page.dart';
import 'package:flutter_application_2/features/home/pages/home_page.dart';
import 'package:flutter_application_2/features/quitionaire/pages/questionnaire_page.dart';
import '../../features/auth/services/auth_storage.dart';

// import pages
import '../../features/approval/pages/approval_page.dart';
import '../../features/dashboard/pages/dashboard_page.dart';
import '../../features/profile/pages/profile_page.dart';
import '../../features/user/pages/user_page.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int currentIndex = 0;

  List<Widget> pages = [];
  List<BottomNavigationBarItem> items = [];

  @override
  void initState() {
    super.initState();
    setupMenu();
  }

  void setupMenu() async {
    final role = await AuthStorage().getRole();

    List<Widget> tempPages = [];
    List<BottomNavigationBarItem> tempItems = [];

    // ================= GURU =================
    if (role == UserRole.guru) {
      tempPages = [
        const DashboardPage(),
        const AssignmentPage(),
        const ProfilePage(),
      ];

      tempItems = const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment),
          label: 'Penilaian',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ];
    }
    // ================= KEPSEK / ADMIN =================
    else if (role == UserRole.kepsek || role == UserRole.admin) {
      tempPages = [
        const ApprovalPage(),
        const DashboardPage(),
        const UserPage(),
      ];

      tempItems = const [
        BottomNavigationBarItem(icon: Icon(Icons.check), label: 'Approval'),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.people), label: 'User'),
      ];
    }

    setState(() {
      pages = tempPages;
      items = tempItems;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (pages.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        items: items,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
