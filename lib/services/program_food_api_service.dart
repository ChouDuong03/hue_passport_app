import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hue_passport_app/models/dish_model_2.dart';
import 'package:hue_passport_app/models/location_model.dart';
import 'package:hue_passport_app/models/location_model_2.dart';
import 'package:hue_passport_app/models/program_food_detail_model.dart';
import 'package:hue_passport_app/models/program_food_model.dart';
import 'package:hue_passport_app/models/dish_model.dart';
import 'package:hue_passport_app/models/program_progess.dart';
import 'package:hue_passport_app/models/program_time.dart';
import 'package:hue_passport_app/models/top_checkin_user_model.dart';
import 'package:hue_passport_app/models/dish_detail_model.dart';
import 'package:hue_passport_app/models/review_response.dart';
import 'package:hue_passport_app/models/experiencestat_model.dart';
import 'package:hue_passport_app/models/review_model.dart'; // Import file mới
import 'package:hue_passport_app/screen/login/secure_storage_service.dart';
import 'package:get/get.dart';

class ProgramFoodApiService {
  static const baseUrl = 'https://localhost:54450/api/ChuongTrinhAmThucs';
  static const dishBaseUrl = 'https://localhost:54450/api/MonAns';
  static const thongKeBaseUrl = 'https://localhost:54450/api/ThongKes';
  static const danhSachQuanAn = 'https://localhost:54450/api/DiaDiemMonAns';
  static const nhanQuaBaseUrl =
      'https://localhost:54450/api/ho-chieu-hanh-khach/NhanQua';

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
    final dish2 = await fetchDishesByProgram2(chuongTrinhID);
    if (dish2.isEmpty) {
      return [];
    }

    final List<DishModel> dish = [];
    String currentLanguage = Get.locale?.languageCode ?? 'vi';
    int targetLanguageId = languageIdMap[currentLanguage] ?? 1;

    for (var dishes2 in dish2) {
      try {
        final dishDetail = await fetchDishDetail(dishes2.monAnID);
        if (dishDetail.childMonAnChiTiets.isNotEmpty &&
            dishDetail.childMonAnChiTiets
                .any((detail) => detail.ngonNguID == targetLanguageId)) {
          dish.add(DishModel(
            id: dishes2.monAnID,
            chuongTrinhID: dishes2.chuongTrinhID,
            tenMon: dishDetail.tenMon,
            maLoai: 0,
            kieuMon: dishDetail.kieuMon,
            thucUong: dishDetail.thucUong,
            amThucId: 0,
            anhDaiDien: '',
            ngonNguID: targetLanguageId,
            isCheckedIn: dishes2.isCheckedIn,
          ));
        }
      } catch (e) {
        print('Error fetching dish detail for monAnID ${dishes2.monAnID}: $e');
        continue;
      }
    }

    return dish;
  }

  Future<List<DishModel2>> fetchDishesByProgram2(int chuongTrinhID) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('https://localhost:54450/api/Accounts/get-lichsu-checkin'),
      headers: token != null ? {'Authorization': 'Bearer $token'} : {},
    );
    final data = await _handleResponse(response);
    List list = data['resultObj'];
    String currentLanguage = Get.locale?.languageCode ?? 'vi';
    int targetLanguageId = languageIdMap[currentLanguage] ?? 1;
    return list
        .map((e) => DishModel2.fromJson(e))
        .where((dish) =>
            dish.ngonNguID == targetLanguageId &&
            dish.chuongTrinhID == chuongTrinhID)
        .toList();
  }

  Future<List<TopCheckInUserModel>> fetchTop5CheckInUsers() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$thongKeBaseUrl/ThongKeTopCheckIn'),
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

  Future<LocationModel> fetchLocationDetail(int locationId) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$danhSachQuanAn/GetDiaDiemChiTiet/$locationId'),
      headers: token != null ? {'Authorization': 'Bearer $token'} : {},
    );
    final data = await _handleResponse(response);
    return LocationModel.fromJson(data);
  }

  Future<List<LocationModel>> fetchLocationsByDish(int dishId) async {
    final locations2 = await fetchLocationsByDish2(dishId);
    if (locations2.isEmpty) {
      return [];
    }

    final List<LocationModel> locations = [];
    String currentLanguage = Get.locale?.languageCode ?? 'vi';
    int targetLanguageId = languageIdMap[currentLanguage] ?? 1;

    for (var location2 in locations2) {
      try {
        final locationDetail = await fetchLocationDetail(location2.quanAnID);
        if (locationDetail.childGetDiaDiemByMonAns
            .any((detail) => detail.ngonNguID == targetLanguageId)) {
          locations.add(locationDetail);
        }
      } catch (e) {
        print(
            'Error fetching location detail for quanAnID ${location2.quanAnID}: $e');
        continue;
      }
    }

    return locations;
  }

  Future<List<LocationModel2>> fetchLocationsByDish2(int dishId) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('https://localhost:54450/api/Accounts/get-lichsu-checkin'),
      headers: token != null ? {'Authorization': 'Bearer $token'} : {},
    );
    final data = await _handleResponse(response);
    List list = data['resultObj'];

    String currentLanguage = Get.locale?.languageCode ?? 'vi';
    int targetLanguageId = languageIdMap[currentLanguage] ?? 1;
    return list
        .map((e) => LocationModel2.fromJson(e))
        .where((location) =>
            location.ngonNguID == targetLanguageId &&
            location.monAnID == dishId)
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

  Future<int> fetchCheckInFoodCount() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('https://localhost:54450/api/MonAns/DemSoMonAnCheckin'),
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
          '$baseUrl/TienDoThamGiaVaHoanThanhChuongTrinh?chuongTrinhID=$chuongTrinhID'),
      headers: token != null ? {'Authorization': 'Bearer $token'} : {},
    );
    final data = await _handleResponse(response);
    return ProgramTime.fromJson(data);
  }

  // API kiểm tra trạng thái xác nhận/hủy bỏ
  Future<bool> checkConfirmationStatus(int chuongTrinhID) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$nhanQuaBaseUrl/KiemTra?chuongTrinhID=$chuongTrinhID'),
      headers: token != null ? {'Authorization': 'Bearer $token'} : {},
    );
    final data = await _handleResponse(response);
    return data['isSuccessed'] as bool;
  }

  // API xử lý khi bấm "Xác nhận"
  Future<Map<String, dynamic>> confirmReward(int chuongTrinhID) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$nhanQuaBaseUrl/cl-XacNhan?chuongTrinhID=$chuongTrinhID'),
      headers: token != null ? {'Authorization': 'Bearer $token'} : {},
    );
    final data = await _handleResponse(response);
    return {
      'isSuccessed': data['isSuccessed'] as bool,
      'message': data['message'] as String,
    };
  }

  // API gửi review địa điểm sử dụng ReviewModel
  Future<bool> postReviewDiaDiem(ReviewModel review) async {
    const String reviewUrl = '$danhSachQuanAn/ReViewDiaDiem';
    final token = await _getToken();

    try {
      final response = await http.post(
        Uri.parse(reviewUrl),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(review.toJson()),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print("Lỗi gửi review: ${response.statusCode}, ${response.body}");
        return false;
      }
    } catch (e) {
      print("Lỗi khi gửi review: $e");
      return false;
    }
  }

  Future<List<ReviewModel2>> fetchReviewsByLocation(int diaDiemID,
      {int pageSize = 5}) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse(
          '$danhSachQuanAn/GetDSReViewDiaDiemByID?diaDiemID=$diaDiemID&pageSize=$pageSize'),
      headers: token != null ? {'Authorization': 'Bearer $token'} : {},
    );

    final data = await _handleResponse(response);
    final reviewResponse = ReviewResponse.fromJson(data);

    // Kiểm tra isSuccessed trước khi trả về
    if (!reviewResponse.isSuccessed) {
      throw Exception(reviewResponse.message);
    }

    return reviewResponse.resultObj;
  }

  Future<List<ExperienceStatsModel>> fetchExperienceStats(
      int chuongTrinhID) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse(
          '$thongKeBaseUrl/ThongKeDiemKinhNghiem?chuongTrinhID=$chuongTrinhID'),
      headers: token != null ? {'Authorization': 'Bearer $token'} : {},
    );

    final data = await _handleResponse(response);
    final statsResponse = ExperienceStatsResponse.fromJson(data);

    if (!statsResponse.isSuccessed) {
      throw Exception(statsResponse.message);
    }

    return statsResponse.resultObj;
  }
}
