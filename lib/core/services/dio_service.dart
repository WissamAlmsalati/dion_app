import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
            'https://dionv2-csbtgbecbxcybxfg.italynorth-01.azurewebsites.net/api/',
        connectTimeout: const Duration(seconds: 2000),
        receiveTimeout: const Duration(seconds: 2000),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

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
        onError: (DioError error, ErrorInterceptorHandler handler) async {
          print('Error: ${error.message}');

          // Check if the error status code is 401 (Unauthorized)
          if (error.response?.statusCode == 401) {
            await _handleUnauthorized();
          }
          // Pass the error along
          return handler.next(error);
        },
      ),
    );
  }


  Future<void> _handleUnauthorized() async {
    const storage = FlutterSecureStorage();
    await storage.deleteAll();
    print('User logged out due to 401 Unauthorized error.');
    
  }

  Future<Response> get(String endpoint,
      {Map<String, dynamic>? queryParams,
      required Map<String, String> queryParameters}) async {
    return await dio.get(endpoint, queryParameters: queryParams);
  }

  Future<Response> post(String endpoint, {dynamic data}) async {
    return await dio.post(endpoint, data: data);
  }

  Future<Response> put(String endpoint, {dynamic data}) async {
    return await dio.put(endpoint, data: data);
  }

  Future<Response> delete(String endpoint) async {
    return await dio.delete(endpoint);
  }
}
