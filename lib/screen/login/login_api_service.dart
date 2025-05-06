import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hue_passport_app/screen/login/login_response.dart';
import 'secure_storage_service.dart';

class LoginApiService {
  final SecureStorageService storageService = SecureStorageService();

  Future<ResultObj?> login({
    required String passportNumber,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('https://localhost:51394/api/Accounts/DangNhap'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'TaiKhoan': passportNumber,
        'MatKhau': password,
      }),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final loginResponse = LoginResponse.fromJson(body);

      if (loginResponse.isSuccessed) {
        final resultObj = loginResponse.resultObj!;
        // Lưu token vào secure storage
        await storageService.saveAccessToken(resultObj.accessToken!);
        await storageService.saveRefreshToken(resultObj.refreshToken!);
        return resultObj;
      } else {
        throw Exception(loginResponse.message);
      }
    } else {
      throw Exception('Đăng nhập thất bại: ${response.body}');
    }
  }
}
