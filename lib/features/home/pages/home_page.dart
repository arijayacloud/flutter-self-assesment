import 'package:flutter/material.dart';
import '../../assessment/services/assessment_service.dart';
import '../../quitionaire/pages/questionnaire_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;

  String status = "Belum Submit";
  double lastScore = 0;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final data = await AssessmentService().getMyAssessments();

    if (data.isNotEmpty) {
      final latest = data.first;

      setState(() {
        status = latest['status'];
        lastScore = (latest['total_score'] ?? 0).toDouble();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Color getStatusColor(String status) {
    if (status == 'approved') return Colors.green;
    if (status == 'rejected') return Colors.red;
    if (status == 'submitted') return Colors.orange;
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Guru'),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// GREETING
                  const Text(
                    'Halo 👋',
                    style: TextStyle(fontSize: 20),
                  ),

                  const SizedBox(height: 16),

                  /// STATUS CARD
                  Card(
                    child: ListTile(
                      title: const Text('Status Assessment'),
                      subtitle: Text(status),
                      trailing: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: getStatusColor(status),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          status,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// SCORE CARD
                  Card(
                    child: ListTile(
                      title: const Text('Nilai Terakhir'),
                      subtitle: Text(lastScore.toString()),
                      trailing: const Icon(Icons.bar_chart),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const QuestionnairePage(),
                          ),
                        );
                      },
                      child: const Text('Isi Penilaian'),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// MENU CEPAT
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [

                      _menuItem(Icons.history, 'Riwayat', () {}),

                      _menuItem(Icons.person, 'Profile', () {}),

                    ],
                  )
                ],
              ),
            ),
    );
  }

  Widget _menuItem(IconData icon, String title, VoidCallback onTap) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: CircleAvatar(
            radius: 28,
            child: Icon(icon),
          ),
        ),
        const SizedBox(height: 6),
        Text(title)
      ],
    );
  }
}