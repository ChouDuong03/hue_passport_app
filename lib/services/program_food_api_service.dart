import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hue_passport_app/models/program_food_detail_model.dart';
import 'package:hue_passport_app/models/program_food_model.dart';
import 'package:hue_passport_app/models/dish_model.dart';
import 'package:hue_passport_app/models/top_checkin_user_model.dart';
import 'package:hue_passport_app/models/dish_detail_model.dart';

class ProgramFoodApiService {
  static const baseUrl = 'https://localhost:51125/api/ChuongTrinhAmThucs';
  static const dishBaseUrl = 'https://localhost:51125/api/MonAns';
  static const thongKeBaseUrl = 'https://localhost:51125/api/ThongKes';

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

  // Lấy danh sách món ăn theo chương trình
  static Future<List<DishModel>> fetchDishesByProgram(int chuongTrinhID) async {
    final response = await http.get(
      Uri.parse('$dishBaseUrl/GetDanhSachMonAnByChuongTrinh/$chuongTrinhID'),
    );
    final data = await _handleResponse(response);
    List list = data['resultObj'];
    return list.map((e) => DishModel.fromJson(e)).toList();
  }

  // Lấy danh sách top 5 người dùng check-in
  static Future<List<TopCheckInUserModel>> fetchTop5CheckInUsers() async {
    final response = await http.get(
      Uri.parse('$thongKeBaseUrl/ThongKeTop5CheckIn'),
    );
    final data = await _handleResponse(response);
    List list = data['resultObj'];
    return list.map((e) => TopCheckInUserModel.fromJson(e)).toList();
  }

  static Future<DishDetailModel> fetchDishDetail(int id) async {
    final response =
        await http.get(Uri.parse('$dishBaseUrl/GetChiTietMonAn/$id'));
    final data = await _handleResponse(response);
    return DishDetailModel.fromJson(data);
  }
}
