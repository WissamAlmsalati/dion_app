import 'package:dio/dio.dart';
import 'package:dion_app/core/services/dio_service.dart';
import '../data/models/loaning_data.dart';
import '../../../core/services/auth_token_service.dart';

class LoaningRepository {
  final AuthService authService;
  final DioService dioService;

  LoaningRepository({
    required this.authService,
    required this.dioService,
  });

  Future<LoaningData> fetchLoaningData() async {
    final token = await authService.getToken();

    try {
      final response = await dioService.dio.get(
        'Loaning/main',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      print('Response Data: ${response.data}');
      print('Response Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        return LoaningData.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to fetch loaning data, status code: ${response.statusCode}');
      }
    } on DioError catch (e) {
      print('Dio error: ${e.message}');
      throw Exception('Failed to fetch loaning data due to Dio error: ${e.message}');
    }
  }
}
