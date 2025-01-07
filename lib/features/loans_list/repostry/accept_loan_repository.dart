import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../authintication_feature/services/auth_service.dart';

class AcceptLoanRepository {
  static const String apiUrl = 'https://dionv2-csbtgbecbxcybxfg.italynorth-01.azurewebsites.net/api/Loaning/UpdateLoanStatus';
  final AuthService authService = AuthService();





   Future<void> updateLoanStatus(int loanId, int loanStatus) async {


    final token = await authService.getToken();

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'

      },
      body: json.encode({
        'loanId': loanId,
        'loanStatus': loanStatus,
      }),
    );
    print(response.body);
    print(response.statusCode);

    if (response.statusCode != 200) {
      throw Exception('Failed to update loan status');
    }
  }
}
