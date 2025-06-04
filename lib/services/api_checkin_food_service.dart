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
  static Future<CheckinResult> postCheckin({
    required int diaDiemId,
    required int chuongTrinhId,
    required int monAnId, // Tham số bắt buộc
    required double viDo,
    required double kinhDo,
  }) async {
    const String apiUrl =
        "https://hochieudulichv2.huecit.com/api/DiaDiemMonAns/CheckIn";
    final token = await _getToken();

    try {
      var request = http.MultipartRequest("POST", Uri.parse(apiUrl));

      // Thêm các field cần thiết
      request.fields['DiaDiemID'] = diaDiemId.toString();
      request.fields['ChuongTrinhID'] = chuongTrinhId.toString();
      request.fields['MonAnID'] = monAnId.toString(); // Bắt buộc gửi MonAnID
      request.fields['ViDo'] = viDo.toString().replaceAll('.', ',');
      request.fields['KinhDo'] = kinhDo.toString().replaceAll('.', ',');

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
      print("Lỗi khi gửi multipart: $e");
      return CheckinResult(success: false);
    }
  }
}
