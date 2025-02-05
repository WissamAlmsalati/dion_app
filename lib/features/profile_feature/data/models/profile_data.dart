


class ProfileData {
  final String username;
  final String email;
  final String phoneNumber;


  ProfileData({
    required this.username,
    required this.email,
    required this.phoneNumber,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
    );
  }
}