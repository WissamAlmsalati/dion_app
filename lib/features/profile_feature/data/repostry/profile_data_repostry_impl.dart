import 'package:dio/dio.dart';
import 'package:dion_app/core/services/auth_token_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dion_app/features/profile_feature/data/models/profile_data.dart';
import 'package:dion_app/features/profile_feature/domain/profile_data_repostry.dart';

class ProfileDataRepostryImpl extends ProfileDataRepository {

AuthService authService ;


  ProfileDataRepostryImpl({required this.authService});
  // API endpoint URL
  final String _endpoint =
      'https://dionv2-csbtgbecbxcybxfg.italynorth-01.azurewebsites.net/api/Loaning/GetUserData';

  @override
  Future<ProfileData> getProfileData() async {
    // Retrieve the token from SharedPreferences
    final token = await authService.getToken();


    if (token == null) {
      throw Exception('Authentication token not found.');
    }

    // Create a Dio instance
    final Dio dio = Dio();

    // Set request headers
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      // Perform the GET request
      final Response response = await dio.get(_endpoint);

      // Check if the response was successful
      if (response.statusCode == 200) {
        // Assuming the response.data is a Map<String, dynamic>
        return ProfileData.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to fetch profile data. Status code: ${response.statusCode}');
      }
    } on DioError catch (e) {
      // You can further inspect e.response, e.message, etc.
      throw Exception('Failed to fetch profile data: ${e.message}');
    }
  }

  @override
  Future<void> updateProfileData(profileData) async {
    // TODO: Implement updateProfileData using Dio if needed.
    throw UnimplementedError();
  }
}
