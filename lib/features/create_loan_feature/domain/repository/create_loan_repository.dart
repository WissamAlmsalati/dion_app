import 'package:dio/dio.dart';
import 'package:dion_app/core/services/dio_service.dart'; // Adjust the path if needed
import 'package:flutter/foundation.dart';
import '../../data/models/loaning_model.dart';
import '../../../../core/services/auth_token_service.dart';

class CreateLoanRepository {
  final AuthService authService;
  final DioService dioService;

  CreateLoanRepository({
    required this.authService,
    required this.dioService,
  });

  Future<void> createLoan(LoaningModel loaningModel) async {
    final token = await authService.getToken();

    try {
      final response = await dioService.dio.post(
        'Loaning/CreateLoan',
        data: loaningModel.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (kDebugMode) {
        print('Request Body: ${loaningModel.toJson()}');
        print('Token: $token');
        print('Response Status Code: ${response.statusCode}');
        print('Response Data: ${response.data}');
      }

      if (response.statusCode != 200) {
        throw 'Failed to create loan, status code: ${response.statusCode}';
      }
    } on DioError catch (e) {
      final errorResponse = e.response?.data;
      String errorMessage = 'Failed to create loan';

      if (errorResponse is Map<String, dynamic> &&
          errorResponse.containsKey('message')) {
        errorMessage = errorResponse['message'];
      }

      if (kDebugMode) {
        print('Dio error: $errorMessage');
      }
      throw errorMessage;
    }
  }
}
