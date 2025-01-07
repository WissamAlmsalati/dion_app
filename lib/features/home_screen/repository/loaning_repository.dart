import 'dart:convert';
import '../../../core/network/http_Interceptor.dart';
import '../models/loaning_data.dart';
import '../../authintication_feature/services/auth_service.dart';

import 'package:http/http.dart' as http;

class LoaningRepository {

  final AuthService authService = AuthService();

  LoaningRepository();

  Future<LoaningData> fetchLoaningData() async {
    final response = await http.get(
      Uri.parse(
          'https://dionv2-csbtgbecbxcybxfg.italynorth-01.azurewebsites.net/api/Loaning/main'
      ),
      headers: {
        'Authorization': 'Bearer ${await authService.getToken()}',
      },
    );

    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      return LoaningData.fromJson(json.decode(response.body));
    } else {
      throw Exception('');
    }
  }
}
