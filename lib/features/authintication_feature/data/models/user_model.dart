class User {
  final String name;
  final String email;
  final String phoneNumber;
  final String password;
  final String fcmToken;
  final String otpCode;
  final String otpId;

  User({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.password,
    required this.fcmToken,
    required this.otpCode,
    required this.otpId,
  });

  // Factory method to create a User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      password: json['password'] ?? '',
      fcmToken: json['fcmToken'] ?? '',
      otpCode: json['otp'] ?? '',
      otpId: json['otpId'] ?? '',
    );
  }

  // Method to convert a User to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'password': password,
      'fcmToken': fcmToken,
      'otp': otpCode,
      'otpId': otpId,
    };
  }
}