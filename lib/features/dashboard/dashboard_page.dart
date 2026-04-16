import 'package:flutter/material.dart';

import '../assessment/pages/assessment_form_page.dart';
import '../auth/pages/login_page.dart';
import '../auth/services/auth_storage.dart';

class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard'), actions: [MaterialButton(onPressed: logout(context), child: const Text('Logout'),)],),
      body: Center(
        child: Column(
          children: [
            const Text('Berhasil Login 🎉'),
            MaterialButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AssessmentFormPage()),
                );
              },
              child: const Text('Lihat Form Penilaian'),
            ),
          ],
        ),
      ),
    );
  }

  // ignore: strict_top_level_inference
  Future<Null> Function() logout(context) {
    return () async {
      final authStorage = AuthStorage();
      await authStorage.clear();
  
      // kembali ke login page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    };
  }
}