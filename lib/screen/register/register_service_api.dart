import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hue_passport_app/screen/register/register_response.dart';
import 'package:hue_passport_app/screen/login/secure_storage_service.dart';

class RegisterApiService {
  final SecureStorageService storageService = SecureStorageService();

  Future<RegisterResultObj?> register({
    required String hoTen,
    required int gioiTinh,
    required String ngaySinh,
    required String hopThu,
    required int quocTichID,
    required int tinhThanhID,
  }) async {
    final response = await http.post(
      // Uri.parse('https://hochieudulichv2.huecit.com/api/Accounts/DangKy'),
      Uri.parse('https://localhost:54450/api/Accounts/DangKy'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'hoTen': hoTen,
        'gioiTinh': gioiTinh,
        'ngaySinh': ngaySinh,
        'hopThu': hopThu,
        'quocTich': quocTichID,
        'tinhThanh': tinhThanhID,
      }),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final registerResponse = RegisterResponse.fromJson(body);

      if (registerResponse.isSuccessed) {
        final resultObj = registerResponse.resultObj!;
        // (nếu cần) bạn có thể lưu thông tin vào storage tại đây
        return resultObj;
      } else {
        throw Exception(registerResponse.message);
      }
    } else {
      throw Exception('Đăng ký thất bại: ${response.body}');
    }
  }
}
