import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_coffee/core/constants/api_constants.dart';

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

class ApiClient {
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: Duration(milliseconds: ApiConstants.connectTimeout),
        receiveTimeout: Duration(milliseconds: ApiConstants.receiveTimeout),
      ),
    );
  }

  Future<Response<dynamic>> get(
      String path, {
        Map<String, dynamic>? queryParameters,
      }) {
    return _retry(() => _dio.get(path, queryParameters: queryParameters));
  }

  Future<Response<dynamic>> post(String path, {dynamic data}) {
    return _retry(() => _dio.post(path, data: data));
  }

  Future<Response<dynamic>> put(String path, {dynamic data}) {
    return _retry(() => _dio.put(path, data: data));
  }

  Future<Response<dynamic>> delete(String path) {
    return _retry(() => _dio.delete(path));
  }

  /// Retry логика: до 3 попыток при ошибках сети/сервера
  Future<Response<dynamic>> _retry(
      Future<Response<dynamic>> Function() request, {
        int maxRetries = ApiConstants.maxRetries,
      }) async {
    int attempt = 0;
    while (true) {
      try {
        attempt++;
        return await request();
      } on DioException catch (e) {
        if (attempt >= maxRetries || !_shouldRetry(e)) rethrow;
        await Future.delayed(Duration(seconds: attempt));
      }
    }
  }

  bool _shouldRetry(DioException e) {
    return e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError ||
        (e.response?.statusCode ?? 0) >= 500;
  }
}