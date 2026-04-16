import 'package:flutter/material.dart';
import '../services/dashboard_service.dart';
import '../models/dashboard_model.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final service = DashboardService();
  DashboardModel? data;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetch();
  }

  Future<void> fetch() async {
    final res = await service.getDashboard();

    setState(() {
      data = res;
      isLoading = false;
    });
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'approved':
        return Colors.green;
      case 'submitted':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (data == null) {
      return const Scaffold(
        body: Center(child: Text('Belum ada data')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Guru'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // 🎯 CARD NILAI
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text('Nilai Terakhir',
                        style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 10),
                    Text(
                      data!.totalScore.toString(),
                      style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Chip(
                      label: Text(data!.status),
                      backgroundColor:
                          getStatusColor(data!.status),
                    )
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 📋 DETAIL
            Expanded(
              child: ListView.builder(
                itemCount: data!.details.length,
                itemBuilder: (context, index) {
                  final d = data!.details[index];

                  return Card(
                    child: ListTile(
                      title: Text(d.name),
                      subtitle: Text('Score: ${d.score}'),
                      trailing: Text(
                        d.finalScore.toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}