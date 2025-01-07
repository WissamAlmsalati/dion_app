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
      print('OTP Response: ${response.body}');
      return json.decode(response.body);
    } else {
      print('OTP Response: ${response.body}');
      throw Exception('Failed to send OTP: ${response.reasonPhrase}');
    }
  }

  Future<Map<String, dynamic>> verifyOtp(String phoneNumber, String otp) async {
    final response = await http.post(
      Uri.parse(ApiConstants.verifyOtpEndpoint),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'phoneNumber': phoneNumber, 'otpCode': otp}),
    );

    print('OTP Verification Response Code: ${response.statusCode}');

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      print('OTP Verification Response: $responseBody');
      return responseBody;
    } else {
      throw Exception('Invalid OTP: ${response.reasonPhrase}');
    }
  }

  // Function for login with phone number and OTP
  Future<Map<String, dynamic>> login(String phoneNumber, String otp) async {
    final response = await http.post(
      Uri.parse(ApiConstants.loginEndpoint),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'phone_number': phoneNumber, 'otp': otp}),
    );

    print('Login Response: ${response.body}');
    print('Login Response Code: ${response.statusCode}');
    print(otp);

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      print('Login Response: $responseBody');
      return responseBody;
    } else {
      throw Exception('Failed to login: ${response.reasonPhrase}');
    }
  }

  // Function for registration with name, email, password, and fcm token
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String fcmToken,
  }) async {
    final response = await http.post(
      Uri.parse(ApiConstants.registerEndpoint),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': name,
        'email': email,
        'password': password,
        'fcm_token': fcmToken,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to register: ${response.reasonPhrase}');
    }
  }
}