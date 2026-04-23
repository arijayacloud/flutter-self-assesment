import 'package:dio/dio.dart';
import '../../features/auth/services/auth_storage.dart';

class ApiClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'http://127.0.0.1:8000/api', // emulator Android
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Accept': 'application/json',
      },
    ),
  );

  static Future<void> setToken() async {
    final token = await AuthStorage().getToken();

    if (token != null) {
      dio.options.headers['Authorization'] = 'Bearer $token';
    }
  }
}