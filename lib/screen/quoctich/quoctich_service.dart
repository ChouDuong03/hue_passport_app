import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hue_passport_app/screen/quoctich/quoctich_model.dart';

class NationalityApi {
  static const String baseUrl = 'https://localhost:58586/API';

  static Future<List<Nationality>> fetchNationalities() async {
    final response = await http.get(Uri.parse('$baseUrl/QuocTich/Gets'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final nationalityResponse = NationalityResponse.fromJson(data);
      return nationalityResponse.resultObj;
    } else {
      throw Exception('Failed to load nationalities');
    }
  }
}
