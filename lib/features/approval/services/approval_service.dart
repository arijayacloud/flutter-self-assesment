import '../models/assessment_model.dart';
import '../../../core/network/api_client.dart';

class ApprovalService {
  Future<List<AssessmentModel>> getData() async {
    await ApiClient.setToken();

    final res = await ApiClient.dio.get('/assessments');

    return (res.data as List)
        .map((e) => AssessmentModel.fromJson(e))
        .toList();
  }

  Future<void> approve(int id) async {
    await ApiClient.setToken();
    await ApiClient.dio.post('/assessments/$id/approve');
  }

  Future<void> reject(int id) async {
    await ApiClient.setToken();
    await ApiClient.dio.post('/assessments/$id/reject');
  }
}