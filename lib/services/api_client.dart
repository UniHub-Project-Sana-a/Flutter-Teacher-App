// lib/services/api_client.dart
import 'package:dio/dio.dart';
import 'endpoints.dart';
import 'storage_service.dart';

class ApiClient {
  ApiClient._();
  static final ApiClient instance = ApiClient._();

  late final Dio dio = _build();

  Dio _build() {
    final d = Dio(BaseOptions(
      baseUrl: Endpoints.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),
      headers: {'Accept': 'application/json'},
    ));

    d.interceptors.add(InterceptorsWrapper(
      onRequest: (opt, handler) {
        final token = StorageService.instance.token;
        if (token != null && token.isNotEmpty) {
          opt.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(opt);
      },
    ));

    return d;
  }
}