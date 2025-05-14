import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hue_passport_app/screen/tinhthanh/province_model.dart';

class ProvinceApiService {
  static const String baseUrl = 'https://localhost:51512/api';

  // Lấy danh sách tỉnh thành
  static Future<List<Province>> fetchProvinces() async {
    final response = await http.get(Uri.parse('$baseUrl/DiaPhuongs/Gets'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final provinceResponse = ProvinceResponse.fromJson(data);
      return provinceResponse.resultObj;
    } else {
      throw Exception('Không tải được danh sách tỉnh thành');
    }
  }

  // Cập nhật tỉnh thành cho user hiện tại
  static Future<void> updateProvince({
    required String passportNumber,
    required String provinceID,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/Accounts/update-tinhthanh-dukhach'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'taikhoan': passportNumber,
        'tinhThanhId': int.parse(provinceID),
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Lỗi kết nối API');
    }

    final body = jsonDecode(response.body);
    if (body['isSuccessed'] != true) {
      throw Exception(body['message'] ?? 'Cập nhật thất bại');
    }
  }
}
