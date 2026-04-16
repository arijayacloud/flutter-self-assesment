import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../models/criteria_model.dart';

class CriteriaService {
  Future<List<CriteriaModel>> getCriteria() async {
    try {
      final response = await ApiClient.dio.get('/criteria');

      final List data = response.data;

      return data.map((e) => CriteriaModel.fromJson(e)).toList();

    } on DioException {
      throw Exception('Gagal ambil data');
    }
  }
}