import 'package:http/http.dart' as http;
import 'package:hue_passport_app/screen/login/secure_storage_service.dart';

class CheckinResult {
  final bool success;

  CheckinResult({required this.success});
}

final SecureStorageService storageService = SecureStorageService();
Future<String?> _getToken() async {
  return await storageService.getAccessToken();
}

class ApiCheckinFoodService {
  static Future<CheckinResult> postCheckinMultipart({
    required int monAnId,
    required int chuongTrinhId,
    required double viDo,
    required double kinhDo,
  }) async {
    const String apiUrl = "https://localhost:50529/api/MonAns/CheckIn";
    final token = await _getToken();

    try {
      var request = http.MultipartRequest("POST", Uri.parse(apiUrl));

      // Thêm các field cần thiết
      request.fields['MonAnID'] = monAnId.toString();
      request.fields['ChuongTrinhID'] = chuongTrinhId.toString();
      request.fields['ViDo'] = viDo.toString();
      request.fields['KinhDo'] = kinhDo.toString();

      // Thêm header Authorization nếu có token
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      // Gửi request
      var response = await request.send();

      if (response.statusCode == 200) {
        return CheckinResult(success: true);
      } else {
        print("Lỗi response: ${response.statusCode}");
        return CheckinResult(success: false);
      }
    } catch (e) {
      print(" Lỗi khi gửi multipart: $e");
      return CheckinResult(success: false);
    }
  }

  static Future<CheckinResult> postCheckinDiaDiem({
    required int diaDiemId,
    required int chuongTrinhId,
    required double viDo,
    required double kinhDo,
  }) async {
    // const String apiUrl ="https://localhost:50529/api/DiaDiemMonAns/CheckIn";
    const String apiUrl = "https://localhost:50529/api/DiaDiemMonAns/CheckIn";
    final token = await _getToken();

    try {
      var request = http.MultipartRequest("POST", Uri.parse(apiUrl));

      request.fields['DiaDiemID'] = diaDiemId.toString();
      request.fields['ChuongTrinhID'] = chuongTrinhId.toString();
      request.fields['ViDo'] = viDo.toString();
      request.fields['KinhDo'] = kinhDo.toString();

      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        return CheckinResult(success: true);
      } else {
        print("Lỗi response địa điểm: ${response.statusCode}");
        return CheckinResult(success: false);
      }
    } catch (e) {
      print("Lỗi khi gửi multipart địa điểm: $e");
      return CheckinResult(success: false);
    }
  }
}
