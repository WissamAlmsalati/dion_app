import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/network/api_constants.dart';

class AuthRepository {
  Future<Map<String, dynamic>> sendOtp(String phoneNumber) async {
    final response = await http.get(
      Uri.parse('${ApiConstants.sendOtpEndpoint}$phoneNumber'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw AuthException('Failed to send OTP: ${response.reasonPhrase}');
    }
  }

  Future<void> verifyOtp(String phoneNumber, String otpCode) async {
    final response = await http.post(
      Uri.parse(ApiConstants.verifyOtpEndpoint),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'phoneNumber': phoneNumber, 'otpCode': otpCode}),
    );

    print("OTP Verification Response Code: ${response.statusCode}");
    print("OTP Verification Response: ${response.body}");

    if (response.statusCode != 200) {
      final responseBody = json.decode(response.body);
      final errorMessage = responseBody['message'] ?? 'Failed to verify OTP';
      throw AuthException(errorMessage);
    }
  }

  Future<void> signUp(Map<String, dynamic> user) async {
    final response = await http.post(
      Uri.parse(ApiConstants.registerEndpoint),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user),
    );
    print("SignUp Response Code: ${response.statusCode}");
    print("SignUp Response: ${response.body}");
    if (response.statusCode != 200) {
      final responseBody = json.decode(response.body);
      final errorMessage = responseBody['message'] ?? 'Failed to register';
      throw AuthException(errorMessage);
    }
  }

  Future<Map<String, dynamic>> login(
      String phoneNumber, String password) async {
    print(phoneNumber);
    print(password);
    final response = await http.post(
      Uri.parse(ApiConstants.loginEndpoint),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'phoneNumber': phoneNumber, 'password': password}),
    );

    print("Login Response Code: ${response.statusCode}");
    print("Login Response: ${response.body}");

    if (response.statusCode != 200) {
      throw AuthException('${response.reasonPhrase}');
    }

    return json.decode(response.body);
  }
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}
