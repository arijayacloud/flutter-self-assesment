import 'package:flutter/material.dart';
import 'core/navigation/main_navigation.dart';
import 'features/auth/services/auth_storage.dart';
import 'features/auth/pages/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Widget> _getInitialPage() async {
    final authStorage = AuthStorage();

    final token = await authStorage.getToken();
    // final role = await authStorage.getRole();

    // if (token == null || role == null) {
    //   return const LoginPage();
    // }

    // if (role == UserRole.guru) {
    //   return const AssessmentFormPage();
    // } else if (role == UserRole.kepsek || role == UserRole.admin) {
    //   return const DashboardPage();
    // }

    // return const LoginPage();

    if (token == null) {
      return const LoginPage();
    }

    return const MainNavigation();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      title: 'Sekolah App',
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: _getInitialPage(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          return snapshot.data!;
        },
      ),
    );
  }
}
