// lib/repositories/auth_repository.dart
import 'package:dio/dio.dart';
import '../services/api_client.dart';
import '../services/endpoints.dart';

class AuthRepository {
  final _dio = ApiClient.instance.dio;

  Future<(String token, String name)> login({
    required String userOrEmail,
    required String password,
  }) async {
    final res = await _dio.post(
      Endpoints.login,
      data: {'username': userOrEmail, 'password': password},
    );
    final data = res.data as Map<String, dynamic>;
    final token = data['token'] as String;
    final name = (data['user']?['name'] as String?) ?? 'مستخدم';
    return (token, name);
  }
}