import 'package:dio/dio.dart';
import 'package:dion_app/core/services/services.dart'; // Adjust the path if needed
import '../models/loaning_model.dart';
import '../../authintication_feature/services/auth_service.dart';

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

      print('Request Body: ${loaningModel.toJson()}');
      print('Token: $token');
      print('Response Status Code: ${response.statusCode}');
      print('Response Data: ${response.data}');

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to create loan, status code: ${response.statusCode}',
        );
      }
    } on DioError catch (e) {
      print('Dio error: ${e.message}');
      throw Exception('Failed to create loan due to Dio error: ${e.message}');
    }
  }
}
