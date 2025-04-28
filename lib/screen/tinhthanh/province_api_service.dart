import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hue_passport_app/screen/tinhthanh/province_model.dart';

class ProvinceApiService {
  static const String baseUrl = 'https://localhost:50860/API';

  static Future<List<Province>> fetchProvinces() async {
    final response = await http.get(Uri.parse('$baseUrl/TinhThanh/Gets'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final provinceResponse = ProvinceResponse.fromJson(data);
      return provinceResponse.resultObj;
    } else {
      throw Exception('Failed to load provinces');
    }
  }
}
