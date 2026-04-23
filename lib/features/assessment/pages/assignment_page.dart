import 'package:flutter/material.dart';
import 'package:flutter_application_2/features/quitionaire/pages/questionnaire_page.dart';
import '../../../shared/widgets/empty_state.dart';
import '../services/assignment_service.dart';
import '../models/assignment_model.dart';
import '../widgets/assignment_card.dart';

class AssignmentPage extends StatefulWidget {
  const AssignmentPage({super.key});

  @override
  State<AssignmentPage> createState() => _AssignmentPageState();
}

class _AssignmentPageState extends State<AssignmentPage> {

  final AssignmentService _service = AssignmentService();

  List<Assignment> assignments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() => isLoading = true);

    final data = await _service.getAssignments();

    setState(() {
      assignments = data;
      isLoading = false;
    });
  }

  void goToQuestionnaire(Assignment item) {
    Navigator.pushNamed(
      context,
      '/questionnaire',
      arguments: item.date,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assignment Saya'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchData,
          )
        ],
      ),

      body: RefreshIndicator(
        onRefresh: fetchData,

        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : assignments.isEmpty
                ? const EmptyState(message: 'Tidak ada assignment')
                : ListView.builder(
                    itemCount: assignments.length,
                    itemBuilder: (context, index) {

                      final item = assignments[index];

                      return AssignmentCard(
                        assignment: item,
                        onTap: () => goToQuestionnaire(item),
                      );
                    },
                  ),
      ),
    );
  }

  
}