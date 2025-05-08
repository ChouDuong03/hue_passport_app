import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hue_passport_app/models/location_model.dart';
import 'package:hue_passport_app/models/program_food_detail_model.dart';
import 'package:hue_passport_app/models/program_food_model.dart';
import 'package:hue_passport_app/models/dish_model.dart';
import 'package:hue_passport_app/models/top_checkin_user_model.dart';
import 'package:hue_passport_app/models/dish_detail_model.dart';
import 'package:get/get.dart';

class ProgramFoodApiService {
  static const baseUrl = 'https://localhost:51379/api/ChuongTrinhAmThucs';
  static const dishBaseUrl = 'https://localhost:51379/api/MonAns';
  static const thongKeBaseUrl = 'https://localhost:51379/api/ThongKes';
  static const danhSachQuanAn = 'https://localhost:51379/api/DiaDiemMonAns';

  static const Map<String, int> languageIdMap = {
    'vi': 1, // Tiếng Việt
    'en': 4, // Tiếng Anh
  };

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

  static Future<List<ProgramFoodModel>> fetchPrograms() async {
    final response = await http.get(Uri.parse('$baseUrl/Gets'));
    final data = await _handleResponse(response);
    List list = data['resultObj'];
    return list.map((e) => ProgramFoodModel.fromJson(e)).toList();
  }

  static Future<ProgramFoodDetailModel> fetchProgramDetail(int id) async {
    final response =
        await http.get(Uri.parse('$baseUrl/GetChiTietChuongTrinh/$id'));
    final data = await _handleResponse(response);
    return ProgramFoodDetailModel.fromJson(data['resultObj']);
  }

  static Future<List<DishModel>> fetchDishesByProgram(int chuongTrinhID) async {
    final response = await http.get(
        Uri.parse('$dishBaseUrl/GetDanhSachMonAnByChuongTrinh/$chuongTrinhID'));
    final data = await _handleResponse(response);
    List list = data['resultObj'];
    return list.map((e) => DishModel.fromJson(e)).toList();
  }

  static Future<List<TopCheckInUserModel>> fetchTop5CheckInUsers() async {
    final response =
        await http.get(Uri.parse('$thongKeBaseUrl/ThongKeTop5CheckIn'));
    final data = await _handleResponse(response);
    List list = data['resultObj'];

    String currentLanguage = Get.locale?.languageCode ?? 'vi';
    int targetLanguageId = languageIdMap[currentLanguage] ?? 1;

    return list
        .map((e) => TopCheckInUserModel.fromJson(e))
        .where((user) => user.ngonNguID == targetLanguageId)
        .toList();
  }

  // Sửa lại để lấy danh sách địa điểm theo dishId
  static Future<List<LocationModel>> fetchLocationsByDish(int dishId) async {
    final response = await http
        .get(Uri.parse('$danhSachQuanAn/GetDanhSachDiaDiemByMonAn/$dishId'));
    final data = await _handleResponse(response);
    List list = data['resultObj'];

    String currentLanguage = Get.locale?.languageCode ?? 'vi';
    int targetLanguageId = languageIdMap[currentLanguage] ?? 1;

    return list
        .map((e) => LocationModel.fromJson(e))
        .where((location) => location.ngonNguID == targetLanguageId)
        .toList();
  }

  static Future<DishDetailModel> fetchDishDetail(int id) async {
    final response =
        await http.get(Uri.parse('$dishBaseUrl/GetChiTietMonAn/$id'));
    final data = await _handleResponse(response);
    return DishDetailModel.fromJson(data);
  }
}
