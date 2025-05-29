import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hue_passport_app/screen/tinhthanh/province_model.dart';
import 'package:hue_passport_app/screen/login/secure_storage_service.dart'; // Import SecureStorageService

class ProvinceApiService {
  final SecureStorageService storageService = SecureStorageService();

  Future<String?> _getToken() async {
    return await storageService.getAccessToken();
  }

  // Lấy danh sách tỉnh thành
  static Future<List<Province>> fetchProvinces() async {
    final response = await http.get(
      Uri.parse('https://localhost:50529/api/DiaPhuongs/Gets'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final provinceResponse = ProvinceResponse.fromJson(data);
      return provinceResponse.resultObj;
    } else {
      throw Exception(
          'Không tải được danh sách tỉnh thành: ${response.statusCode}, ${response.body}');
    }
  }

  // Cập nhật tỉnh thành cho user hiện tại
  Future<void> updateProvince({
    required String provinceID,
  }) async {
    final token = await _getToken();

    // Kiểm tra provinceID trước khi parse
    if (provinceID.isEmpty || !RegExp(r'^\d+$').hasMatch(provinceID)) {
      throw Exception('provinceID không hợp lệ: $provinceID');
    }

    final response = await http.put(
      Uri.parse(
          'https://localhost:50529/api/Accounts/update-tinhthanh-dukhach'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null)
          'Authorization': 'Bearer $token', // Thêm token vào header
      },
      body: jsonEncode({
        'tinhThanhId': int.parse(provinceID),
      }),
    );

    if (response.statusCode != 200) {
      print(
          'Lỗi response: ${response.statusCode}, ${response.body}'); // In chi tiết lỗi
      throw Exception(
          'Lỗi kết nối API: ${response.statusCode}, ${response.body}');
    }

    final body = jsonDecode(response.body);
    if (body['isSuccessed'] != true) {
      print('Thông báo từ server: ${body['message']}');
      throw Exception(body['message'] ?? 'Cập nhật thất bại');
    }
  }
}
