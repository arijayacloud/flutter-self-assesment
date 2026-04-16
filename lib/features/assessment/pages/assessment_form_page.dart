import 'package:flutter/material.dart';
import '../../auth/pages/login_page.dart';
import '../../auth/services/auth_storage.dart';
import '../../quitionaire/models/questionnaire_model.dart';
import '../models/criteria_model.dart';
import '../services/criteria_service.dart';
import '../services/assessment_service.dart';

class AssessmentFormPage extends StatefulWidget {
  const AssessmentFormPage({super.key});

  @override
  State<AssessmentFormPage> createState() => _AssessmentFormPageState();
}

class _AssessmentFormPageState extends State<AssessmentFormPage> {
  final service = CriteriaService();

  List<CriteriaModel> criteriaList = [];
  Map<int, int> scores = {}; // id -> nilai
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
    try {
      final data = await service.getCriteria();

      setState(() {
        criteriaList = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  final assessmentService = AssessmentService();

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

    try {
      await assessmentService.submit(details);

      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(const SnackBar(content: Text('Berhasil disimpan')));
    } catch (e) {
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Widget buildDropdown(CriteriaModel item) {
    return DropdownButtonFormField<int>(
      initialValue: scores[item.id],
      decoration: InputDecoration(labelText: item.name),
      items: [1, 2, 3, 4, 5].map((value) {
        return DropdownMenuItem(value: value, child: Text(value.toString()));
      }).toList(),
      onChanged: (value) {
        setState(() {
          scores[item.id] = value!;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Form Penilaian'), actions: [ MaterialButton(onPressed: logout(context), child: const Text('Logout'),)],),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: criteriaList.length,
                itemBuilder: (context, index) {
                  final item = criteriaList[index];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: buildDropdown(item),
                  );
                },
              ),
            ),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: submit,
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  logout(context) {
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
