import 'package:flutter/material.dart';
import '../models/questionnaire_model.dart';
import '../services/questionnaire_service.dart';
import '../../assessment/services/assessment_service.dart';
import '../widgets/question_item.dart';

class QuestionnairePage extends StatefulWidget {
  const QuestionnairePage({super.key});

  @override
  State<QuestionnairePage> createState() => _QuestionnairePageState();
}

class _QuestionnairePageState extends State<QuestionnairePage> {

  final QuestionnaireService _service = QuestionnaireService();
  final AssessmentService _submitService = AssessmentService();

  List<Questionnaire> questions = [];
  Map<int, int> answers = {}; // questionId -> score

  bool isLoading = true;
  bool isSubmitting = false;

  String date = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    date = ModalRoute.of(context)!.settings.arguments as String;

    fetchData();
  }

  Future<void> fetchData() async {
    final data = await _service.getByDate(date);

    setState(() {
      questions = data;
      isLoading = false;
    });
  }

  void onAnswer(int id, int value) {
    setState(() {
      answers[id] = value;
    });
  }

  Future<void> submit() async {
    if (answers.length != questions.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua pertanyaan harus diisi')),
      );
      return;
    }

    setState(() => isSubmitting = true);

    final details = answers.entries.map((e) {
      return {
        "criteria_id": e.key,
        "score": e.value,
      };
    }).toList();

    final success = await _submitService.submit(details);

    setState(() => isSubmitting = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Berhasil submit')),
      );

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal submit')),
      );
    }
  }

  Map<String, List<Questionnaire>> grouped() {
    final Map<String, List<Questionnaire>> data = {};

    for (var q in questions) {
      data.putIfAbsent(q.category, () => []);
      data[q.category]!.add(q);
    }

    return data;
  }

  @override
  Widget build(BuildContext context) {

    final groupedData = grouped();

    return Scaffold(
      appBar: AppBar(
        title: Text('Isi Assessment'),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [

                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(12),
                    children: groupedData.entries.map((entry) {

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          // CATEGORY
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              entry.key,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          // QUESTIONS
                          ...entry.value.map((q) {
                            return QuestionItem(
                              question: q.question,
                              value: answers[q.id],
                              onChanged: (val) => onAnswer(q.id, val),
                            );
                          })

                        ],
                      );
                    }).toList(),
                  ),
                ),

                // SUBMIT BUTTON
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isSubmitting ? null : submit,
                      child: isSubmitting
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Submit'),
                    ),
                  ),
                )
              ],
            ),
    );
  }
}