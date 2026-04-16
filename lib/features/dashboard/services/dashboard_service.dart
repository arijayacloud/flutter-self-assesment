import '../../../core/network/api_client.dart';
import '../models/dashboard_model.dart';

class DashboardService {
  Future<DashboardModel?> getDashboard() async {
    try {
      await ApiClient.setToken();

      final response = await ApiClient.dio.get('/my-dashboard');
      print(  response.data);

      return DashboardModel.fromJson(response.data);
    } catch (e) {
      print(e);
      return null;
    }
  }
}