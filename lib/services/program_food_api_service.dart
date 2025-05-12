import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hue_passport_app/models/location_model.dart';
import 'package:hue_passport_app/models/location_model_2.dart';
import 'package:hue_passport_app/models/program_food_detail_model.dart';
import 'package:hue_passport_app/models/program_food_model.dart';
import 'package:hue_passport_app/models/dish_model.dart';
import 'package:hue_passport_app/models/program_progess.dart';
import 'package:hue_passport_app/models/program_time.dart';
import 'package:hue_passport_app/models/top_checkin_user_model.dart';
import 'package:hue_passport_app/models/dish_detail_model.dart';
import 'package:hue_passport_app/screen/login/secure_storage_service.dart';
import 'package:get/get.dart';

class ProgramFoodApiService {
  static const baseUrl = 'https://localhost:58586/api/ChuongTrinhAmThucs';
  static const dishBaseUrl = 'https://localhost:58586/api/MonAns';
  static const thongKeBaseUrl = 'https://localhost:58586/api/ThongKes';
  static const danhSachQuanAn = 'https://localhost:58586/api/DiaDiemMonAns';

  static const Map<String, int> languageIdMap = {
    'vi': 1, // Tiếng Việt
    'en': 4, // Tiếng Anh
  };

  final SecureStorageService storageService = SecureStorageService();

  Future<String?> _getToken() async {
    return await storageService.getAccessToken();
  }

  static Future<Map<String, dynamic>> _handleResponse(
      http.Response response) async {
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    } else {
      throw Exception(
          'Failed to load data, status code: ${response.statusCode}, message: ${response.body}');
    }
  }

  Future<List<ProgramFoodModel>> fetchPrograms() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/Gets'),
      headers: token != null ? {'Authorization': 'Bearer $token'} : {},
    );
    final data = await _handleResponse(response);
    List list = data['resultObj'];
    return list.map((e) => ProgramFoodModel.fromJson(e)).toList();
  }

  Future<ProgramFoodDetailModel> fetchProgramDetail(int id) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/GetChiTietChuongTrinh/$id'),
      headers: token != null ? {'Authorization': 'Bearer $token'} : {},
    );
    final data = await _handleResponse(response);
    return ProgramFoodDetailModel.fromJson(data['resultObj']);
  }

  Future<List<DishModel>> fetchDishesByProgram(int chuongTrinhID) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$dishBaseUrl/GetDanhSachMonAnByChuongTrinh/$chuongTrinhID'),
      headers: token != null ? {'Authorization': 'Bearer $token'} : {},
    );
    final data = await _handleResponse(response);
    List list = data['resultObj'];
    return list.map((e) => DishModel.fromJson(e)).toList();
  }

  Future<List<TopCheckInUserModel>> fetchTop5CheckInUsers() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$thongKeBaseUrl/ThongKeTop5CheckIn'),
      headers: token != null ? {'Authorization': 'Bearer $token'} : {},
    );
    final data = await _handleResponse(response);
    List list = data['resultObj'];
    String currentLanguage = Get.locale?.languageCode ?? 'vi';
    int targetLanguageId = languageIdMap[currentLanguage] ?? 1;
    return list
        .map((e) => TopCheckInUserModel.fromJson(e))
        .where((user) => user.ngonNguID == targetLanguageId)
        .toList();
  }

  Future<List<LocationModel>> fetchLocationsByDish(int dishId) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$danhSachQuanAn/GetDanhSachDiaDiemByMonAn/$dishId'),
      headers: token != null ? {'Authorization': 'Bearer $token'} : {},
    );
    final data = await _handleResponse(response);
    List list = data['resultObj'];
    String currentLanguage = Get.locale?.languageCode ?? 'vi';
    int targetLanguageId = languageIdMap[currentLanguage] ?? 1;
    return list
        .map((e) => LocationModel.fromJson(e))
        .where((location) => location.ngonNguID == targetLanguageId)
        .toList();
  }

  Future<List<LocationModel2>> fetchLocationsByDish2(int dishId) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse(
          'https://localhost:58586/api/Accounts/lichsu-checkin?monAnID=$dishId'),
      headers: token != null ? {'Authorization': 'Bearer $token'} : {},
    );
    final data = await _handleResponse(response);
    List list = data['resultObj'];

    String currentLanguage = Get.locale?.languageCode ?? 'vi';
    int targetLanguageId = languageIdMap[currentLanguage] ?? 1;
    return list
        .map((e) => LocationModel2.fromJson(e))
        .where((location) => location.ngonNguID == targetLanguageId)
        .toList();
  }

  Future<DishDetailModel> fetchDishDetail(int id) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$dishBaseUrl/GetChiTietMonAn/$id'),
      headers: token != null ? {'Authorization': 'Bearer $token'} : {},
    );
    final data = await _handleResponse(response);
    return DishDetailModel.fromJson(data);
  }

  Future<int> fetchCheckInCount() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$danhSachQuanAn/DemSoDiaDiemCheckin'),
      headers: token != null ? {'Authorization': 'Bearer $token'} : {},
    );
    final data = await _handleResponse(response);
    return data['count'] as int;
  }

  Future<ProgramProgress> fetchProgramProgress(int chuongTrinhID) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse(
          '$baseUrl/TienDoThamGiaVaHoanThanhChuongTrinh?chuongTrinhID=$chuongTrinhID'),
      headers: token != null ? {'Authorization': 'Bearer $token'} : {},
    );
    final data = await _handleResponse(response);
    return ProgramProgress.fromJson(data);
  }

  Future<ProgramTime> fetchProgramTime(int chuongTrinhID) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse(
          '$baseUrl/CheckQuaHanThamGiaChuongTrinh?chuongTrinhID=$chuongTrinhID'),
      headers: token != null ? {'Authorization': 'Bearer $token'} : {},
    );
    final data = await _handleResponse(response);
    return ProgramTime.fromJson(data);
  }
}
