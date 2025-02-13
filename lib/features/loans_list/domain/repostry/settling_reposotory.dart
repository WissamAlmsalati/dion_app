import 'package:dion_app/core/services/auth_token_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SettlingRepository {
  final String apiUrl = 'https://dionv2-csbtgbecbxcybxfg.italynorth-01.azurewebsites.net/api/Loaning/SettlingLoan';
  final String acceptLoanUrl = 'https://dionv2-csbtgbecbxcybxfg.italynorth-01.azurewebsites.net/api/Loaning/UpdateLoanStatus';
  final AuthService authService;

  SettlingRepository({required this.authService});

  Future<String> settleLoan(int loanId, double amount) async {
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

    // Parse the server response to extract a message.
    final decoded = jsonDecode(response.body);
    // Assume the server returns a JSON object with a 'message' key.
    final message = decoded['message'] as String?;
    return message ?? 'تمت تسوية القرض بنجاح!';
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
