import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../authintication_feature/services/auth_service.dart';
import '../models/loaning_model.dart';

class LoaningRepository {
  final String apiUrl =
      'https://dionv2-csbtgbecbxcybxfg.italynorth-01.azurewebsites.net/api/Loaning/CreateLoan';
  final AuthService authService;

  LoaningRepository({required this.authService});

  Future<void> createLoan(LoaningModel loaningModel) async {
    final token = await authService.getToken();

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(loaningModel.toJson()),
    );

    print(token);
    print(response.statusCode);
    print(response.body);

    if (response.statusCode != 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final errorMessage = responseData['message'] ?? 'حدث خطأ غير متوقع.';
      throw errorMessage; // Throw only the error message
    }
  }


}