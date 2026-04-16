import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';

class AuthService {
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await ApiClient.dio.post(
        '/login',
        data: {'email': email, 'password': password},
      );
      // print(response.data);
      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Login gagal');
    }
  }

 
}
