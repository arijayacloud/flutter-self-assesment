import 'package:dio/dio.dart';
import '../../features/auth/services/auth_storage.dart';

class ApiClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://self-assessment.arijayasoftwarehouse.online/api', // emulator Android
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