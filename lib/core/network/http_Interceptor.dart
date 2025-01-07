// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
// import '../../features/authintication_feature/services/auth_service.dart';
//
// class HttpClientWithInterceptor {
//   final http.Client _client;
//   final AuthService authService;
//
//   HttpClientWithInterceptor(this._client, this.authService);
//
//   Future<http.Response> get(String url, {Map<String, String>? headers}) async {
//
//
//     final modifiedHeaders = {
//       ...?headers,
//       'Authorization': 'Bearer ${await authService.getToken()}',
//     };
//
//     print('Request: GET $url');
//     final response = await _client.get(Uri.parse(url), headers: modifiedHeaders);
//
//     _logResponse(response);
//     return response;
//   }
//
//   Future<http.Response> post(String url,
//       {Map<String, String>? headers, Object? body}) async {
//     final modifiedHeaders = {
//       ...?headers,
//       'Authorization': 'Bearer ${await authService.getToken()}',
//       'Content-Type': 'application/json',
//     };
//
//     print('Request: POST $url');
//     print('Body: ${json.encode(body)}');
//     final response = await _client.post(
//       Uri.parse(url),
//       headers: modifiedHeaders,
//       body: json.encode(body),
//     );
//
//     _logResponse(response);
//     return response;
//   }
//
//   void _logResponse(http.Response response) {
//     print('Response: ${response.statusCode}');
//     print('Body: ${response.body}');
//   }
// }
