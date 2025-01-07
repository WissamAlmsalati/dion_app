import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../authintication_feature/services/auth_service.dart';
import '../models/loan.dart';

class LoanRepository {
  final String apiUrl =
      'https://dionv2-csbtgbecbxcybxfg.italynorth-01.azurewebsites.net/api/Loaning/Loans';
  final AuthService authService;

  LoanRepository({required this.authService});

  Future<List<Loan>> fetchLoans({required int page, required int pageSize}) async {
    final token = await authService.getToken();

    final response = await http.get(
      Uri.parse('$apiUrl?status=&page=$page&pageSize=$pageSize'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<Loan> loans =
          (data as List).map((loanData) => Loan.fromJson(loanData)).toList();
      return loans;
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
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Loan.fromJson(data);
    } else {
      throw Exception('Failed to load loan details');
    }
  }
}