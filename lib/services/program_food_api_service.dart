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
import 'package:hue_passport_app/models/review_model.dart';
import 'package:hue_passport_app/models/ranking_model.dart';
import 'package:hue_passport_app/screen/login/secure_storage_service.dart';
import 'package:hue_passport_app/models/user_info_model.dart';
import 'package:get/get.dart';

class ProgramFoodApiService {
  static const baseUrl = 'hochieu/api/ChuongTrinhAmThucs';
  static const dishBaseUrl = 'hochieu/api/MonAns';
  static const thongKeBaseUrl = 'hochieu/api/ThongKes';
  static const danhSachQuanAn = 'hochieu/api/DiaDiemMonAns';
  static const nhanQuaBaseUrl = 'hochieu/api/ho-chieu-hanh-khach/NhanQua';

  static const Map<String, int> languageIdMap = {
    'vi': 1, // Tiếng Việt
    'en': 4, // Tiếng Anh
  };

  final SecureStorageService storageService = SecureStorageService();

  Future<String?> _getToken() async {
    String? token = await storageService.getAccessToken();
    if (token == null) {
      token = await storageService.refreshAccessToken();
    }
    return token;
  }

  static Future<Map<String, dynamic>> _handleResponse(
      http.Response response) async {
    if (response.statusCode == 200) {
      try {
        final data = json.decode(response.body);
        return data;
      } catch (e) {
        throw Exception('Failed to parse JSON: $e');
      }
    } else {
      throw Exception(
          'Failed to load data, status code: ${response.statusCode}, message: ${response.body}');
    }
  }

  Future<List<ProgramFoodModel>> fetchPrograms({int ngonNguID = 1}) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/Gets?ngonNguID=$ngonNguID'),
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
    String currentLanguage = Get.locale?.languageCode ?? 'vi';
    int targetLanguageId = languageIdMap[currentLanguage] ?? 1;

    // Lấy danh sách món ăn từ API mới
    final dishResponse = await http.get(
      Uri.parse(
          '$dishBaseUrl/GetDanhSachMonAnByChuongTrinh/$chuongTrinhID?ngonNguID=$targetLanguageId'),
      headers: token != null ? {'Authorization': 'Bearer $token'} : {},
    );
    final dishData = await _handleResponse(dishResponse);
    if (!dishData['isSuccessed'] || dishData['resultObj'] == null) {
      return [];
    }
    List<dynamic> dishList = dishData['resultObj'];

    // Lấy danh sách check-in để xác định trạng thái isCheckedIn
    final checkinResponse = await http.get(
      Uri.parse('hochieu/api/Accounts/get-lichsu-checkin'),
      headers: token != null ? {'Authorization': 'Bearer $token'} : {},
    );
    final checkinData = await _handleResponse(checkinResponse);
    if (!checkinData['isSuccessed'] || checkinData['resultObj'] == null) {
      return dishList.map((e) => DishModel.fromJson(e)).toList();
    }
    List<dynamic> checkinList = checkinData['resultObj'];

    // Tạo danh sách DishModel và cập nhật isCheckedIn
    return dishList.map((dishJson) {
      bool isCheckedIn = checkinList.any((checkin) =>
          checkin['chuongTrinhID'] == chuongTrinhID &&
          checkin['monAnID'] == dishJson['id'] &&
          checkin['ngonNguID'] == targetLanguageId &&
          checkin['isCheckedIn'] == true);
      return DishModel(
        id: dishJson['id'],
        chuongTrinhID: chuongTrinhID,
        tenMon: dishJson['tenMon'],
        maLoai: dishJson['maLoai'] ?? 0,
        kieuMon: dishJson['kieuMon'] ?? 0,
        thucUong: dishJson['thucUong'] ?? false,
        amThucId: dishJson['amThucId'] ?? 0,
        anhDaiDien: dishJson['anhDaiDien'],
        ngonNguID: dishJson['ngonNguID'] ?? targetLanguageId,
        isCheckedIn: isCheckedIn,
      );
    }).toList();
  }

  // Loại bỏ fetchDishesByProgram2 vì không còn cần thiết
  // Future<List<DishModel2>> fetchDishesByProgram2(int chuongTrinhID) async { ... }

  Future<List<TopCheckInUserModel>> fetchTop5CheckInUsers(
      {int pageSize = 5}) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$thongKeBaseUrl/ThongKeTopCheckIn?pageSize=$pageSize'),
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
    String currentLanguage = Get.locale?.languageCode ?? 'vi';
    int targetLanguageId = languageIdMap[currentLanguage] ?? 1;

    final response = await http.get(
      Uri.parse(
          '$danhSachQuanAn/GetDiaDiemChiTiet/$locationId?ngonNguID=$targetLanguageId'),
      headers: token != null ? {'Authorization': 'Bearer $token'} : {},
    );
    final data = await _handleResponse(response);
    return LocationModel.fromJson(data);
  }

  Future<List<LocationModel>> fetchLocationsByDish(int dishId) async {
    final token = await _getToken();
    String currentLanguage = Get.locale?.languageCode ?? 'vi';
    int targetLanguageId = languageIdMap[currentLanguage] ?? 1;

    // Lấy danh sách địa điểm từ API mới
    final locationResponse = await http.get(
      Uri.parse(
          '$danhSachQuanAn/GetDanhSachDiaDiemByMonAn/$dishId?ngonNguID=$targetLanguageId'),
      headers: token != null ? {'Authorization': 'Bearer $token'} : {},
    );
    final locationData = await _handleResponse(locationResponse);
    if (!locationData['isSuccessed'] || locationData['resultObj'] == null) {
      return [];
    }
    List<dynamic> locationList = locationData['resultObj'];

    // Lấy danh sách check-in
    final checkinResponse = await http.get(
      Uri.parse('hochieu/api/Accounts/get-lichsu-checkin'),
      headers: token != null ? {'Authorization': 'Bearer $token'} : {},
    );
    final checkinData = await _handleResponse(checkinResponse);
    if (!checkinData['isSuccessed'] || checkinData['resultObj'] == null) {
      return locationList
          .map((e) => LocationModel.fromJson({'resultObj': e}))
          .toList();
    }
    List<dynamic> checkinList = checkinData['resultObj'];

    return locationList.map((locationJson) {
      bool isCheckedIn = checkinList.any((checkin) =>
          checkin['monAnID'] == dishId &&
          checkin['quanAnID'] == locationJson['id'] &&
          checkin['ngonNguID'] == targetLanguageId &&
          (checkin['isCheckedIn'] == true ||
              checkin['isCheckedIn'] == 1 ||
              checkin['isCheckedIn'] == 'true'));
      return LocationModel(
        id: locationJson['id'],
        anhDaiDien: locationJson['anhDaiDien'],
        soGiayPhep: locationJson['soGiayPhep'],
        linhVucKinhDoanhId: locationJson['linhVucKinhDoanhId'],
        hangSao: locationJson['hangSao'] ?? 0,
        loaiHinhId: locationJson['loaiHinhId'],
        dienTichMatBang: locationJson['dienTichMatBang'] ?? 0,
        soTang: locationJson['soTang'] ?? 0,
        soNha: locationJson['soNha'],
        phuongXaId: locationJson['phuongXaId'] ?? 0,
        quanHuyenId: locationJson['quanHuyenId'] ?? 0,
        tinhThanhId: locationJson['tinhThanhId'] ?? 0,
        soDienThoai: locationJson['soDienThoai'],
        fax: locationJson['fax'],
        email: locationJson['email'],
        website: locationJson['website'],
        hoTenNguoiDaiDien: locationJson['hoTenNguoiDaiDien'],
        thoiDiemBatDauKinhDoanh: locationJson['thoiDiemBatDauKinhDoanh'],
        gioDongCua: locationJson['gioDongCua'] ?? '',
        gioMoCua: locationJson['gioMoCua'] ?? '',
        toaDoX: (locationJson['toaDoX'] as num).toDouble(),
        toaDoY: (locationJson['toaDoY'] as num).toDouble(),
        banKinhQuyUoc: locationJson['banKinhQuyUoc'] ?? 0,
        ngayCVDatChuan: locationJson['ngayCVDatChuan'],
        soCVDatChuan: locationJson['soCVDatChuan'],
        nhaCungCapId: locationJson['nhaCungCapId'],
        phucVu: locationJson['phucVu'],
        maDoanhNghiep: locationJson['maDoanhNghiep'],
        thuocHoChieu: locationJson['thuocHoChieu'] ?? false,
        childGetDiaDiemByMonAns: [
          LocationDetail(
            noiDungID: 0,
            ngonNguID: targetLanguageId,
            tenDiaDiem: locationJson['tenDiaDiem'] ?? '',
            duongPho: locationJson['duongPho'] ?? '',
            ghiChu: null,
            tenVietTat: '',
            gioiThieu: '',
            tenLoai: '',
            moTa: '',
          ),
        ],
        chuongTrinhID: checkinList.isNotEmpty
            ? checkinList.first['chuongTrinhID'] as int?
            : null,
        monAnID: dishId,
        ngonNguID: targetLanguageId,
        isCheckedIn: isCheckedIn,
      );
    }).toList();
  }

  Future<DishDetailModel> fetchDishDetail(int id) async {
    final token = await _getToken();
    String currentLanguage = Get.locale?.languageCode ?? 'vi';
    int targetLanguageId = languageIdMap[currentLanguage] ?? 1;

    final response = await http.get(
      Uri.parse('$dishBaseUrl/GetChiTietMonAn/$id?ngonNguID=$targetLanguageId'),
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
      Uri.parse('hochieu/api/MonAns/DemSoMonAnCheckin'),
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

  Future<Map<String, dynamic>> confirmReward(int chuongTrinhID) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse(
          'hochieu/api/ho-chieu-hanh-khach/NhanQua/cl-XacNhan?chuongTrinhID=$chuongTrinhID'),
      headers: token != null ? {'Authorization': 'Bearer $token'} : {},
    );

    final data = await _handleResponse(response);
    return {
      'isSuccessed': data['isSuccessed'] as bool,
    };
  }

  Future<bool> checkConfirmationStatus(int chuongTrinhID) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$nhanQuaBaseUrl/KiemTra?chuongTrinhID=$chuongTrinhID'),
      headers: token != null ? {'Authorization': 'Bearer $token'} : {},
    );
    final data = await _handleResponse(response);
    return data['isSuccessed'] as bool;
  }

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
      {int ngonNguID = 1}) async {
    final token = await _getToken();

    final response = await http.get(
      Uri.parse(
          '$danhSachQuanAn/GetDSReViewDiaDiemByID?diaDiemID=$diaDiemID&NgonNguID=$ngonNguID'),
      headers: token != null ? {'Authorization': 'Bearer $token'} : {},
    );

    final data = await _handleResponse(response);
    final reviewResponse = ReviewResponse.fromJson(data);

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

  Future<UserInfoModel> getUserInfo() async {
    final token = await _getToken();
    final url = Uri.parse('hochieu/API/UserInfo');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    final data = await _handleResponse(response);
    if (data['isSuccessed']) {
      return UserInfoModel.fromJson(data['resultObj']);
    } else {
      throw Exception(data['message'] ?? 'Lấy thông tin người dùng thất bại');
    }
  }

  Future<bool> updateUserInfo({
    required String hoTen,
    required int gioiTinh,
    required String ngaySinh,
    required int quocTich,
    String diaChi = '',
    String soDienThoai = '',
    required int tinhThanh,
  }) async {
    final token = await _getToken();
    final url = Uri.parse('hochieu/API/User/ChinhSua-TinhThanh');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'hoTen': hoTen,
        'gioiTinh': gioiTinh,
        'ngaySinh': ngaySinh,
        'quocTich': quocTich,
        'diaChi': diaChi,
        'soDienThoai': soDienThoai,
        'tinhThanh': tinhThanh,
      }),
    );

    final data = await _handleResponse(response);
    return data['isSuccessed'] as bool;
  }

  Future<List<RankingModel>> fetchRankings(int chuongTrinhID,
      {int ngonNguID = 1}) async {
    final token = await _getToken();
    final url = Uri.parse(
      'hochieu/api/ThamGiaChuongTrinhMonAns/GetRankByChuongTrinhID?ngonNguID=$ngonNguID&chuongTrinhID=$chuongTrinhID',
    );

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      print(
          'fetchRankings Response: Status ${response.statusCode}, Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['isSuccessed'] == true) {
          final List<dynamic> resultObj = data['resultObj'];
          return resultObj.map((json) => RankingModel.fromJson(json)).toList();
        } else {
          throw Exception(data['message'] ?? 'Lấy danh sách xếp hạng thất bại');
        }
      } else {
        throw Exception('Lỗi server: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching rankings: $e');
      throw Exception('Lỗi khi lấy danh sách xếp hạng: $e');
    }
  }
}
