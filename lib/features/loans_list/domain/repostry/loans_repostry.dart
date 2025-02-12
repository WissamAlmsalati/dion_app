import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../authintication_feature/services/auth_service.dart';
import '../../data/models/loan.dart';

class LoanRepository {
  final String apiUrl =
      'https://dionv2-csbtgbecbxcybxfg.italynorth-01.azurewebsites.net/api/Loaning/Loans';
  final AuthService authService;

  LoanRepository({required this.authService});

  /// Fetches loans by type. The API expects a query parameter named "loanType".
  Future<Map<String, dynamic>> fetchLoans({
    required int page,
    required int pageSize,
    required String loanType,
  }) async {
    final token = await authService.getToken();

    final response = await http.get(
      Uri.parse(
          '$apiUrl?status=&loanType=$loanType&page=$page&pageSize=$pageSize'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> loansJson = data['loans'];
      final List<Loan> loans = loansJson
          .map((loanData) => Loan.fromJson(loanData))
          .toList();
      final int remainingLoansCount = data['remainingLoansCount'] ?? 0;

      return {
        'loans': loans,
        'remainingLoansCount': remainingLoansCount,
      };
    } else {
      throw Exception('Failed to load loans');
    }
  }

  Future<Loan> getLoanDetails(int loanId) async {
    final token = await authService.getToken();

    final response = await http.get(
      Uri.parse('$apiUrl/$loanId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Loan.fromJson(data);
    } else {
      throw Exception('Failed to load loan details');
    }
  }
}
