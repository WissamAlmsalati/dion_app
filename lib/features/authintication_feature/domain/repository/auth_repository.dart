import 'package:dio/dio.dart';
import 'package:dion_app/core/services/dio_service.dart'; // Adjust the import path as needed (or use service_locator.dart)
import 'package:dion_app/core/services/api_constants.dart';
  
class AuthRepository {
  final DioService dioService = DioService();

  Future<Map<String, dynamic>> sendOtp(String phoneNumber) async {
    try {
      final Response response = await dioService.dio.get(
        '${ApiConstants.sendOtpEndpoint}$phoneNumber',
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw AuthException('Failed to send OTP: ${response.statusMessage}');
      }
    } on DioError catch (e) {
      throw AuthException('Failed to send OTP: ${e.message}');
    }
  }

  Future<void> verifyOtp(String phoneNumber, String otpCode) async {
    try {
      final Response response = await dioService.dio.post(
        ApiConstants.verifyOtpEndpoint,
        data: {
          'phoneNumber': phoneNumber,
          'otpCode': otpCode,
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      print("OTP Verification Response Code: ${response.statusCode}");
      print("OTP Verification Response: ${response.data}");

      if (response.statusCode != 200) {
        final errorMessage = (response.data is Map && response.data['message'] != null)
            ? response.data['message']
            : 'Failed to verify OTP';
        throw AuthException(errorMessage);
      }
    } on DioError catch (e) {
      print("Dio error: ${e.message}");
      throw AuthException('Failed to verify OTP: ${e.message}');
    }
  }

  Future<void> signUp(Map<String, dynamic> user) async {
    try {
      final Response response = await dioService.dio.post(
        ApiConstants.registerEndpoint,
        data: user,
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      print("SignUp Response Code: ${response.statusCode}");
      print("SignUp Response: ${response.data}");

      if (response.statusCode != 200) {
        final errorMessage = (response.data is Map && response.data['message'] != null)
            ? response.data['message']
            : 'Failed to register';
        throw AuthException(errorMessage);
      }
    } on DioError catch (e) {
      throw AuthException('Failed to register: ${e.message}');
    }
  }

  Future<Map<String, dynamic>> login(String phoneNumber, String password) async {
    try {
      final Response response = await dioService.dio.post(
        ApiConstants.loginEndpoint,
        data: {
          'phoneNumber': phoneNumber,
          'password': password,
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      print("Login Response Code: ${response.statusCode}");
      print("Login Response: ${response.data}");

      if (response.statusCode != 200) {
        throw AuthException(response.statusMessage ?? 'Login failed');
      }
      return response.data;
    } on DioError catch (e) {
      throw AuthException('Failed to login: ${e.message}');
    }
  }
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}
