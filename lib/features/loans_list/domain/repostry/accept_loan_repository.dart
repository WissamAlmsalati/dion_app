import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/services/auth_token_service.dart';

class AcceptLoanRepository {
  static const String apiUrl = 'https://dionv2-csbtgbecbxcybxfg.italynorth-01.azurewebsites.net/api/Loaning/UpdateLoanStatus';
  final AuthService authService = AuthService();

  Future<String> updateLoanStatus(int loanId, String loanStatus) async {
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

    print(loanId);
    print("token is $token");
    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseBody = json.decode(response.body);
      return responseBody['message'];
    } else {
      final responseBody = json.decode(response.body);
      if (responseBody is Map && responseBody.containsKey('message')) {
        return Future.error(responseBody['message']); // Return the error message from the backend
      } else {
        return Future.error('Failed to update loan status');
      }
    }
  }
}