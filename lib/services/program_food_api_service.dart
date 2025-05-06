import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hue_passport_app/models/program_food_detail_model.dart';
import 'package:hue_passport_app/models/program_food_model.dart';

class ProgramFoodApiService {
  static const baseUrl = 'https://localhost:51394/api/ChuongTrinhAmThucs';

  // Hàm xử lý chung cho việc kiểm tra thành công của API
  static Future<Map<String, dynamic>> _handleResponse(
      http.Response response) async {
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['isSuccessed']) {
        return data;
      } else {
        throw Exception('API returned failure: ${data['message']}');
      }
    } else {
      throw Exception(
          'Failed to load data, status code: ${response.statusCode}');
    }
  }

  // Lấy danh sách các chương trình
  static Future<List<ProgramFoodModel>> fetchPrograms() async {
    final response = await http.get(Uri.parse('$baseUrl/Gets'));
    final data = await _handleResponse(response);
    List list = data['resultObj'];
    return list.map((e) => ProgramFoodModel.fromJson(e)).toList();
  }

  // Lấy chi tiết của một chương trình
  static Future<ProgramFoodDetailModel> fetchProgramDetail(int id) async {
    final response =
        await http.get(Uri.parse('$baseUrl/GetChiTietChuongTrinh/$id'));
    final data = await _handleResponse(response);
    return ProgramFoodDetailModel.fromJson(data['resultObj']);
  }
}
