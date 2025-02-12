class ApiConstants {
  static const String baseUrl = "https://dionv2-csbtgbecbxcybxfg.italynorth-01.azurewebsites.net/";
  static const String loginEndpoint = "${baseUrl}api/auth/Login";
  static const String registerEndpoint = "${baseUrl}api/auth/Register";
  static const String sendOtpEndpoint = "${baseUrl}api/auth/request-otp?phoneNumber=";
  static const String verifyOtpEndpoint = "${baseUrl}/api/auth/verify-otp";
  static const String resetPasswordEndpoint = "${baseUrl}api/auth/reset-password";
}