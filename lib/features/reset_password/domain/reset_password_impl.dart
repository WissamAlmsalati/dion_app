import 'package:dion_app/core/network/api_constants.dart';
import 'package:dion_app/core/network/services.dart';
import 'package:dion_app/features/authintication_feature/repository/auth_repository.dart';
import 'package:dio/dio.dart';

import '../data/reset_password_repostry.dart';

class ResetPasswordImpl extends ResetPasswordRepository {
  final Dio _dio = Dio();



  @override 
  Future<Map<String, dynamic>> sendOtp({required String phoneNumber}) async {
    final response = await _dio.get(
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
  }


  @override
  Future<String> resetPassword({
    required int otpId,
    required int otp,
    required String newPassword,
  }) async {
    final response = await _dio.put(
      ApiConstants.resetPasswordEndpoint,
      options: Options(
        headers: {'Content-Type': 'application/json'},
      ),
      data: {
        'otpId': otpId,
        'otp': otp,
        'newPassword': newPassword,
      },
    );

    print(otpId  + otp  ) ;

    print(newPassword);

    print(response.statusCode);
    print(response.data); //

    if (response.statusCode == 200) {
      return response.data['message'];
    } else {
      throw AuthException('Failed to reset password: ${response.statusMessage}');
    }
  }

  
}

