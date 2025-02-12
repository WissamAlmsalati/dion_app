import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<String?> getToken() async {
    try {
      return await _storage.read(key: 'AuthToken');
    } catch (e) {
      throw Exception('Failed to read token: ${e.toString()}');
    }
  }

  Future<void> saveToken(String token) async {
    try {
      await _storage.write(key: 'AuthToken', value: token);
    } catch (e) {
      throw Exception('Failed to save token: ${e.toString()}');
    }
  }

  Future<void> clearToken() async {
    try {
      await _storage.delete(key: 'AuthToken');
    } catch (e) {
      throw Exception('Failed to clear token: ${e.toString()}');
    }
  }
}
