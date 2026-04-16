import 'package:flutter/material.dart';
import '../../assessment/services/assessment_service.dart';
import '../models/questionnaire_model.dart';
import '../services/questionnaire_service.dart';

class QuestionnairePage extends StatefulWidget {
  const QuestionnairePage({super.key});

  @override
  State<QuestionnairePage> createState() => _QuestionnairePageState();
}

class _QuestionnairePageState extends State<QuestionnairePage> {
  final _formKey = GlobalKey<FormState>();

  List<QuestionnaireModel> data = [];
  Map<int, TextEditingController> controllers = {};

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final result = await QuestionnaireService().getMyQuestionnaires();

    for (var q in result) {
      controllers[q.id] = TextEditingController();
    }

    setState(() {
      data = result;
      isLoading = false;
    });
  }

  void submit() async {
    if (!_formKey.currentState!.validate()) return;

    List<Map<String, dynamic>> details = [];

    for (var q in data) {
      final value = int.tryParse(controllers[q.id]!.text) ?? 0;

      details.add({
        "questionnaire_id": q.id,
        "score": value,
      });
    }

    // print("details: $details");

    await AssessmentService().submit(details);

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Berhasil submit')),
    );

    // Navigator.pop(context);
  }

  Color getTypeColor(String type) {
    return type == 'positive' ? Colors.green : Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Self Assessment'),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: Column(
                children: [

                  /// LIST
                  Expanded(
                    child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final q = data[index];

                        return Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                /// TITLE
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        q.name,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),

                                    /// TYPE BADGE
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: getTypeColor(q.type),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        q.type,
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                    )
                                  ],
                                ),

                                const SizedBox(height: 10),

                                /// INPUT SCORE
                                TextFormField(
                                  controller: controllers[q.id],
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'Nilai (1 - 5)',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Wajib diisi';
                                    }

                                    final val = int.tryParse(value);
                                    if (val == null || val < 1 || val > 5) {
                                      return 'Nilai 1 - 5';
                                    }

                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  /// BUTTON
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: submit,
                        child: const Text('Submit Penilaian'),
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}