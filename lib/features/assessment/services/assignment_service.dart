import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../models/assignment_model.dart';

class AssignmentService {
  final Dio _dio = ApiClient.dio;

  /// ===============================
  /// GET ASSIGNMENTS (LIST HARIAN)
  /// ===============================
  Future<List<Assignment>> getAssignments() async {
    try {
      await ApiClient.setToken();

      final response = await _dio.get('/assignments');

      if (response.statusCode == 200) {
        return (response.data as List)
            .map((e) => Assignment.fromJson(e))
            .toList();
      }

      return [];
    } catch (e) {
      print('Get Assignments Error: $e');
      return [];
    }
  }
}
