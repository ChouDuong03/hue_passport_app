import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SecureStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> saveAccessToken(String token) async {
    try {
      await _storage.write(key: 'accessToken', value: token);
    } catch (e) {
      throw Exception('Failed to save access token: $e');
    }
  }

  Future<void> saveRefreshToken(String token) async {
    try {
      await _storage.write(key: 'refreshToken', value: token);
    } catch (e) {
      throw Exception('Failed to save refresh token: $e');
    }
  }

  Future<String?> getAccessToken() async {
    try {
      final token = await _storage.read(key: 'accessToken');
      return token;
    } catch (e) {
      print('Error getting access token: $e');
      return null;
    }
  }

  Future<String?> getRefreshToken() async {
    try {
      final token = await _storage.read(key: 'refreshToken');
      return token;
    } catch (e) {
      print('Error getting refresh token: $e');
      return null;
    }
  }

  Future<void> clearAll() async {
    try {
      await _storage.deleteAll();
    } catch (e) {
      throw Exception('Failed to clear storage: $e');
    }
  }

  Future<String?> refreshAccessToken() async {
    final refreshToken = await getRefreshToken();
    if (refreshToken == null) {
      print('No refresh token available');
      return null;
    }

    try {
      final response = await http.post(
        Uri.parse('https://localhost:54450/API/RefreshToken'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'accessToken': await getAccessToken() ?? '',
          'refreshToken': refreshToken,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final newAccessToken = data['accessToken'] as String?;
        final newRefreshToken = data['refreshToken'] as String?;

        if (newAccessToken != null) {
          await saveAccessToken(newAccessToken);
        }
        if (newRefreshToken != null) {
          await saveRefreshToken(newRefreshToken);
        }

        print('Token refreshed successfully');
        return newAccessToken;
      } else {
        print(
            'Token refresh failed: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error refreshing token: $e');
      return null;
    }
  }
}
