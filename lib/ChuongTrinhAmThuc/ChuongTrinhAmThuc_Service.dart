import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hue_passport_app/ChuongTrinhAmThuc/ChuongTrinhAmThucModel.dart';

class ChuongTrinhAmThucService {
  Future<List<ChuongTrinhAmThuc>> fetchChuongTrinh() async {
    final response = await http.get(
        Uri.parse("https://localhost:50788/api/ChuongTrinhAmThucs/Gets"),
        headers: {
          "Content-Type": "application/json",
        });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final list = data['resultObj'] as List;
      return list.map((json) => ChuongTrinhAmThuc.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load chương trình');
    }
  }
}
