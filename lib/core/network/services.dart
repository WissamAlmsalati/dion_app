import 'package:dio/dio.dart';

class DioService {
  static final DioService _instance = DioService._internal();
  late final Dio dio;

  factory DioService() {
    return _instance;
  }

  DioService._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl:
            'https://dionv2-csbtgbecbxcybxfg.italynorth-01.azurewebsites.net/api/', // 🔥 Set your base URL here
        connectTimeout: const Duration(seconds: 2000), // Connection timeout
        receiveTimeout: const Duration(seconds: 2000), // Response timeout
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // ✅ Optional: Add interceptors for logging or authentication
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print('Request: ${options.method} ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('Response: ${response.statusCode}');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          print('Error: ${e.message}');
          return handler.next(e);
        },
      ),
    );
  }

  /// 🔹 GET request
  Future<Response> get(String endpoint,
      {Map<String, dynamic>? queryParams, required Map<String, String> queryParameters}) async {
    return await dio.get(endpoint, queryParameters: queryParams);
  }

  /// 🔹 POST request
  Future<Response> post(String endpoint, {dynamic data}) async {
    return await dio.post(endpoint, data: data);
  }

  /// 🔹 PUT request
  Future<Response> put(String endpoint, {dynamic data}) async {
    return await dio.put(endpoint, data: data);
  }

  /// 🔹 DELETE request
  Future<Response> delete(String endpoint) async {
    return await dio.delete(endpoint);
  }
}
