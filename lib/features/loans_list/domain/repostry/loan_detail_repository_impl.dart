import 'package:dio/dio.dart';
import 'package:dion_app/features/loans_list/data/loan_detail_repository.dart';
import 'package:dion_app/features/loans_list/models/loan.dart';
import 'package:dion_app/features/authintication_feature/services/auth_service.dart';

class LoanDetailRepositoryImpl implements LoanDetailRepository {
  final Dio dio;

  LoanDetailRepositoryImpl({
    required this.dio,
  });

  @override
  Future<Loan> fetchLoanDetail({required int loanId}) async {
    try {
      // Retrieve the token from the auth service.
      final token = await AuthService().getToken();
      final response = await dio.get(
        'https://dionv2-csbtgbecbxcybxfg.italynorth-01.azurewebsites.net/api/Loaning/Loans/$loanId',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      print(response.data);

      final data = response.data;
      Map<String, dynamic> loanJson;

      // If the API returns a list, extract the first item.
      if (data is List && data.isNotEmpty) {
        loanJson = data[0];
      } else if (data is Map<String, dynamic>) {
        loanJson = data;
      } else {
        throw Exception('Unexpected response format');
      }

      return Loan.fromJson(loanJson);
    } catch (e) {
      throw Exception('Error fetching loan detail: $e');
    }
  }
}
