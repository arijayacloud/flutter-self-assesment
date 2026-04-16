import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';

class AssessmentService {
  final Dio _dio = ApiClient.dio;

  /// =========================
  /// SUBMIT ASSESSMENT
  /// =========================
  Future<bool> submit(List<Map<String, dynamic>> details) async {
    try {
      await ApiClient.setToken();

      final response = await _dio.post(
        '/assessments',
        data: {
          "details": details,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
      }
        return true;

      return false;
    } catch (e) {
      print('Submit Error: $e');
      return false;
    }
  }

  /// =========================
  /// GET MY ASSESSMENTS (OPTIONAL)
  /// =========================
  Future<List<dynamic>> getMyAssessments() async {
    try {
      await ApiClient.setToken();

      final response = await _dio.get('/assessments');

      return response.data;
    } catch (e) {
      print('Fetch Error: $e');
      return [];
    }
  }

  /// =========================
  /// APPROVE (Kepsek/Admin)
  /// =========================
  Future<bool> approve(int id) async {
    try {
      await ApiClient.setToken();

      final res = await _dio.post('/assessments/$id/approve');

      return res.statusCode == 200;
    } catch (e) {
      print('Approve Error: $e');
      return false;
    }
  }

  /// =========================
  /// REJECT (Kepsek/Admin)
  /// =========================
  Future<bool> reject(int id) async {
    try {
      await ApiClient.setToken();

      final res = await _dio.post('/assessments/$id/reject');

      return res.statusCode == 200;
    } catch (e) {
      print('Reject Error: $e');
      return false;
    }
  }
}