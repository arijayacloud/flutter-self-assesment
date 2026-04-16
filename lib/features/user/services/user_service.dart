import '../../../core/network/api_client.dart';

class UserService {
  Future<List> getUsers() async {
    await ApiClient.setToken();
    final res = await ApiClient.dio.get('/users');
    return res.data;
  }

  Future<void> create(data) async {
    await ApiClient.setToken();
    await ApiClient.dio.post('/users', data: data);
  }

  Future<void> update(int id, data) async {
    await ApiClient.setToken();
    await ApiClient.dio.put('/users/$id', data: data);
  }

  Future<void> delete(int id) async {
    await ApiClient.setToken();
    await ApiClient.dio.delete('/users/$id');
  }
}