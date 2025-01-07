import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../authintication_feature/services/auth_service.dart';

class SettlingRepository {
  final String apiUrl = 'https://dionv2-csbtgbecbxcybxfg.italynorth-01.azurewebsites.net/api/Loaning/SettlingLoan';
  final String acceptLoanUrl = 'https://dionv2-csbtgbecbxcybxfg.italynorth-01.azurewebsites.net/api/Loaning/UpdateLoanStatus';
  final AuthService authService;

  SettlingRepository({required this.authService});

  Future<void> settleLoan(int loanId, double amount) async {
    final token = await authService.getToken();

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'id': 0,
        'loanId': loanId,
        'amount': amount,
      }),
    );
    print(response.body);
    print(response.statusCode);

    if (response.statusCode != 200) {
      throw Exception('Failed to settle loan: ${response.reasonPhrase}');
    }
  }

  Future<void> updateLoanStatus(int loanId, int status) async {
    final token = await authService.getToken();

    final response = await http.post(
      Uri.parse(acceptLoanUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'loanId': loanId,
        'loanStatus': status,
      }),
    );
    print(response.body);
    print(response.statusCode);

    if (response.statusCode != 200) {
      throw Exception('Failed to accept loan: ${response.reasonPhrase}');
    }
  }
}