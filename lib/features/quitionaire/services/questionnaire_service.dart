import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../models/questionnaire_model.dart';

class QuestionnaireService {
  final Dio _dio = ApiClient.dio;

  Future<List<Questionnaire>> getByDate(String date) async {
    try {
      await ApiClient.setToken();

      final response = await _dio.get(
        '/my-questionnaires?date=$date',
        // queryParameters: {'date': date},
      );
  print(    'Response questionnaires: ${date}'); // Debug print
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((e) => Questionnaire.fromJson(e))
            .toList();
      }

      return [];
    } catch (e) {
      print('Get Questionnaire Error: $e');
      return [];
    }
  }
}