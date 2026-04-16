import 'package:flutter/material.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';
import '../models/assessment_model.dart';
import '../services/approval_service.dart';

class ApprovalPage extends StatefulWidget {
  const ApprovalPage({super.key});

  @override
  State<ApprovalPage> createState() => _ApprovalPageState();
}

class _ApprovalPageState extends State<ApprovalPage> {
  final service = ApprovalService();
  late Future<List<AssessmentModel>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = service.getData();
  }

  void refresh() {
    setState(() {
      futureData = service.getData();
    });
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Approval')),
      body: FutureBuilder<List>(
        future: futureData,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!;

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];

              return AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🔹 HEADER
                    Row(
                      children: [
                        const CircleAvatar(child: Icon(Icons.person)),
                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.user?.name ?? '-',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                item.user?.email ?? '-',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),

                        // STATUS BADGE
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: getStatusColor(item.status),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            item.status,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // 🔽 DETAIL
                    ExpansionTile(
                      title: const Text('Detail Penilaian'),
                      children: item.details.map<Widget>((d) {
                        print (d.criteria?.name);
                        return ListTile(
                          title: Text(d.criteria?.name ?? '-'),
                          trailing: Text(
                            d.score.toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 10),

                    // 🔘 BUTTON ACTION
                    if (item.status == 'submitted')
                      Row(
                        children: [
                          Expanded(
                            child: AppButton(
                              text: 'Approve',
                              color: Colors.green,
                              onPressed: () async {
                                await service.approve(item['id']);
                                refresh();
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: AppButton(
                              text: 'Reject',
                              color: Colors.red,
                              onPressed: () async {
                                await service.reject(item['id']);
                                refresh();
                              },
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
