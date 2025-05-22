import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
      if (token == null) {
      } else {}
      return token;
    } catch (e) {
      return null; // Trả về null nếu có lỗi
    }
  }

  Future<String?> getRefreshToken() async {
    try {
      final token = await _storage.read(key: 'refreshToken');
      if (token == null) {
      } else {}
      return token;
    } catch (e) {
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

  // (Tùy chọn) Phương thức refresh token (nếu cần tích hợp sau)
  Future<String?> refreshAccessToken() async {
    final refreshToken = await getRefreshToken();
    if (refreshToken == null) {
      return null;
    }
    // TODO: Gọi API refresh token từ server và lưu access token mới
    // Ví dụ: await _callRefreshApi(refreshToken);
    return null; // Placeholder, cần triển khai API thực tế
  }
}
