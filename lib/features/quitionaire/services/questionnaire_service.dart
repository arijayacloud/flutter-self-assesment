import '../models/questionnaire_model.dart';
import '../../../core/network/api_client.dart';

class QuestionnaireService {
  Future<List<QuestionnaireModel>> getMyQuestionnaires() async {
    await ApiClient.setToken();

    final res = await ApiClient.dio.get('/my-questionnaires');

    return (res.data as List)
        .map((e) => QuestionnaireModel.fromJson(e))
        .toList();
  }
}