import 'package:flutter/material.dart';

class QuestionItem extends StatelessWidget {
  final String question;
  final int? value;
  final Function(int) onChanged;

  const QuestionItem({
    super.key,
    required this.question,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(question,
                style: const TextStyle(fontWeight: FontWeight.bold)),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(5, (index) {
                final score = index + 1;

                return Column(
                  children: [
                    Text(score.toString()),
                    Radio<int>(
                      value: score,
                      groupValue: value,
                      onChanged: (val) => onChanged(val!),
                    ),
                  ],
                );
              }),
            )

          ],
        ),
      ),
    );
  }
}