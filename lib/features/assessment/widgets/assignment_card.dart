import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/assignment_model.dart';

class AssignmentCard extends StatelessWidget {
  final Assignment assignment;
  final VoidCallback? onTap;

  const AssignmentCard({
    super.key,
    required this.assignment,
    this.onTap,
  });

  String formatDate(String date) {
    final parsed = DateTime.parse(date);
    return DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(parsed);
  }

  @override
  Widget build(BuildContext context) {
    final isCompleted = assignment.status == 'completed';

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),

        title: Text(
          formatDate(assignment.date),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),

        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text('${assignment.totalQuestion} pertanyaan'),
        ),

        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isCompleted ? Icons.check_circle : Icons.pending,
              color: isCompleted ? Colors.green : Colors.orange,
            ),
            const SizedBox(height: 4),
            Text(
              isCompleted ? 'Selesai' : 'Belum',
              style: TextStyle(
                fontSize: 12,
                color: isCompleted ? Colors.green : Colors.orange,
              ),
            ),
          ],
        ),

        onTap: isCompleted ? null : onTap,
      ),
    );
  }
}